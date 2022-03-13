#include <iostream>
#include <Poco/Format.h>
#include <Poco/Util/Application.h>
#include <Poco/Net/SecureServerSocket.h>
#include <Poco/Net/Context.h>
#include <Poco/AutoPtr.h>

using Poco::AutoPtr;
using Poco::Net::Context;
using Poco::Net::SecureServerSocket;

int main()
{
    std::cout << "Hello, World!\n";

    try
    {
        auto context = AutoPtr<Context>(new Context(Context::Usage::SERVER_USE, Context::Params()));
        Poco::Net::ServerSocket unsecure;
        Poco::Net::SecureServerSocket server(context);
        std::cout << (server.secure() ? "YES" : "NO") << '\n';
        std::cout << (unsecure.secure() ? "YES" : "NO") << '\n';
    }
    catch (const std::exception &e)
    {
        std::cout << Poco::format("ERROR: %s", std::string(std::move(e.what()))) << '\n';
        return Poco::Util::Application::EXIT_CONFIG;
    }

    return 0;
}
