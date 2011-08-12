Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab1HLA2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 20:28:38 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:35055 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754147Ab1HLA2h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 20:28:37 -0400
X-Authenticated: #41721828
X-Provags-ID: V01U2FsdGVkX19KsBhBuaxKwD5rt5eDit6K9/XXFqrDFOEDgO53iu
	GyJJLKkrd7npJz
From: =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
To: linux-kernel@vger.kernel.org
Cc: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Randy Dunlap <rdunlap@xenotime.net>,
        user-mode-linux-devel@lists.sourceforge.net,
        =?UTF-8?q?Jonathan=20Neusch=C3=A4fer?= <j.neuschaefer@gmx.net>
Subject: [PATCH] UserModeLinux-HOWTO.txt: remove ^H characters
Date: Fri, 12 Aug 2011 02:28:23 +0200
Message-Id: <1313108903-7351-1-git-send-email-j.neuschaefer@gmx.net>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If you can't read this patch, please run:

	sed -i -e "s/[^\o10]\o10//g" \
		Documentation/virtual/uml/UserModeLinux-HOWTO.txt

Signed-off-by: Jonathan Neuschäfer <j.neuschaefer@gmx.net>
---
 Documentation/virtual/uml/UserModeLinux-HOWTO.txt |  530 ++++++++++----------
 1 files changed, 265 insertions(+), 265 deletions(-)

diff --git a/Documentation/virtual/uml/UserModeLinux-HOWTO.txt b/Documentation/virtual/uml/UserModeLinux-HOWTO.txt
index 5d0fc8b..a7af9cf 100644
--- a/Documentation/virtual/uml/UserModeLinux-HOWTO.txt
+++ b/Documentation/virtual/uml/UserModeLinux-HOWTO.txt
@@ -134,13 +134,13 @@
 
   ______________________________________________________________________
 
-  11..  IInnttrroodduuccttiioonn
+  1.  Introduction
 
   Welcome to User Mode Linux.  It's going to be fun.
 
 
 
-  11..11..  HHooww iiss UUsseerr MMooddee LLiinnuuxx DDiiffffeerreenntt??
+  1.1.  How is User Mode Linux Different?
 
   Normally, the Linux Kernel talks straight to your hardware (video
   card, keyboard, hard drives, etc), and any programs which run ask the
@@ -181,7 +181,7 @@
 
 
 
-  11..22..  WWhhyy WWoouulldd II WWaanntt UUsseerr MMooddee LLiinnuuxx??
+  1.2.  Why Would I Want User Mode Linux?
 
 
   1. If User Mode Linux crashes, your host kernel is still fine.
@@ -206,12 +206,12 @@
 
 
 
-  22..  CCoommppiilliinngg tthhee kkeerrnneell aanndd mmoodduulleess
+  2.  Compiling the kernel and modules
 
 
 
 
-  22..11..  CCoommppiilliinngg tthhee kkeerrnneell
+  2.1.  Compiling the kernel
 
 
   Compiling the user mode kernel is just like compiling any other
@@ -322,7 +322,7 @@
   bug fixes and enhancements that have gone into subsequent releases.
 
 
-  22..22..  CCoommppiilliinngg aanndd iinnssttaalllliinngg kkeerrnneell mmoodduulleess
+  2.2.  Compiling and installing kernel modules
 
   UML modules are built in the same way as the native kernel (with the
   exception of the 'ARCH=um' that you always need for UML):
@@ -386,19 +386,19 @@
 
 
 
-  22..33..  CCoommppiilliinngg aanndd iinnssttaalllliinngg uummll__uuttiilliittiieess
+  2.3.  Compiling and installing uml_utilities
 
   Many features of the UML kernel require a user-space helper program,
   so a uml_utilities package is distributed separately from the kernel
   patch which provides these helpers. Included within this is:
 
-  +o  port-helper - Used by consoles which connect to xterms or ports
+  o  port-helper - Used by consoles which connect to xterms or ports
 
-  +o  tunctl - Configuration tool to create and delete tap devices
+  o  tunctl - Configuration tool to create and delete tap devices
 
-  +o  uml_net - Setuid binary for automatic tap device configuration
+  o  uml_net - Setuid binary for automatic tap device configuration
 
-  +o  uml_switch - User-space virtual switch required for daemon
+  o  uml_switch - User-space virtual switch required for daemon
      transport
 
      The uml_utilities tree is compiled with:
@@ -423,11 +423,11 @@
 
 
 
-  33..  RRuunnnniinngg UUMMLL aanndd llooggggiinngg iinn
+  3.  Running UML and logging in
 
 
 
-  33..11..  RRuunnnniinngg UUMMLL
+  3.1.  Running UML
 
   It runs on 2.2.15 or later, and all 2.4 kernels.
 
@@ -454,7 +454,7 @@
 
 
 
-  33..22..  LLooggggiinngg iinn
+  3.2.  Logging in
 
 
 
@@ -468,7 +468,7 @@
 
   There are a couple of other ways to log in:
 
-  +o  On a virtual console
+  o  On a virtual console
 
 
 
@@ -480,7 +480,7 @@
 
 
 
-  +o  Over the serial line
+  o  Over the serial line
 
 
      In the boot output, find a line that looks like:
@@ -503,7 +503,7 @@
 
 
 
-  +o  Over the net
+  o  Over the net
 
 
      If the network is running, then you can telnet to the virtual
@@ -514,13 +514,13 @@
   down and the process will exit.
 
 
-  33..33..  EExxaammpplleess
+  3.3.  Examples
 
   Here are some examples of UML in action:
 
-  +o  A login session <http://user-mode-linux.sourceforge.net/login.html>
+  o  A login session <http://user-mode-linux.sourceforge.net/login.html>
 
-  +o  A virtual network <http://user-mode-linux.sourceforge.net/net.html>
+  o  A virtual network <http://user-mode-linux.sourceforge.net/net.html>
 
 
 
@@ -528,12 +528,12 @@
 
 
 
-  44..  UUMMLL oonn 22GG//22GG hhoossttss
+  4.  UML on 2G/2G hosts
 
 
 
 
-  44..11..  IInnttrroodduuccttiioonn
+  4.1.  Introduction
 
 
   Most Linux machines are configured so that the kernel occupies the
@@ -546,7 +546,7 @@
 
 
 
-  44..22..  TThhee pprroobblleemm
+  4.2.  The problem
 
 
   The prebuilt UML binaries on this site will not run on 2G/2G hosts
@@ -558,7 +558,7 @@
 
 
 
-  44..33..  TThhee ssoolluuttiioonn
+  4.3.  The solution
 
 
   The fix for this is to rebuild UML from source after enabling
@@ -576,7 +576,7 @@
 
 
 
-  55..  SSeettttiinngg uupp sseerriiaall lliinneess aanndd ccoonnssoolleess
+  5.  Setting up serial lines and consoles
 
 
   It is possible to attach UML serial lines and consoles to many types
@@ -586,12 +586,12 @@
   You can attach them to host ptys, ttys, file descriptors, and ports.
   This allows you to do things like
 
-  +o  have a UML console appear on an unused host console,
+  o  have a UML console appear on an unused host console,
 
-  +o  hook two virtual machines together by having one attach to a pty
+  o  hook two virtual machines together by having one attach to a pty
      and having the other attach to the corresponding tty
 
-  +o  make a virtual machine accessible from the net by attaching a
+  o  make a virtual machine accessible from the net by attaching a
      console to a port on the host.
 
 
@@ -599,7 +599,7 @@
 
 
 
-  55..11..  SSppeecciiffyyiinngg tthhee ddeevviiccee
+  5.1.  Specifying the device
 
   Devices are specified with "con" or "ssl" (console or serial line,
   respectively), optionally with a device number if you are talking
@@ -626,13 +626,13 @@
 
 
 
-  55..22..  SSppeecciiffyyiinngg tthhee cchhaannnneell
+  5.2.  Specifying the channel
 
   There are a number of different types of channels to attach a UML
   device to, each with a different way of specifying exactly what to
   attach to.
 
-  +o  pseudo-terminals - device=pty pts terminals - device=pts
+  o  pseudo-terminals - device=pty pts terminals - device=pts
 
 
      This will cause UML to allocate a free host pseudo-terminal for the
@@ -640,20 +640,20 @@
      log.  You access it by attaching a terminal program to the
      corresponding tty:
 
-  +o  screen /dev/pts/n
+  o  screen /dev/pts/n
 
-  +o  screen /dev/ttyxx
+  o  screen /dev/ttyxx
 
-  +o  minicom -o -p /dev/ttyxx - minicom seems not able to handle pts
+  o  minicom -o -p /dev/ttyxx - minicom seems not able to handle pts
      devices
 
-  +o  kermit - start it up, 'open' the device, then 'connect'
+  o  kermit - start it up, 'open' the device, then 'connect'
 
 
 
 
 
-  +o  terminals - device=tty:tty device file
+  o  terminals - device=tty:tty device file
 
 
      This will make UML attach the device to the specified tty (i.e
@@ -672,7 +672,7 @@
 
 
 
-  +o  xterms - device=xterm
+  o  xterms - device=xterm
 
 
      UML will run an xterm and the device will be attached to it.
@@ -681,7 +681,7 @@
 
 
 
-  +o  Port - device=port:port number
+  o  Port - device=port:port number
 
 
      This will attach the UML devices to the specified host port.
@@ -725,7 +725,7 @@
 
 
 
-  +o  already-existing file descriptors - device=file descriptor
+  o  already-existing file descriptors - device=file descriptor
 
 
      If you set up a file descriptor on the UML command line, you can
@@ -743,7 +743,7 @@
 
 
 
-  +o  Nothing - device=null
+  o  Nothing - device=null
 
 
      This allows the device to be opened, in contrast to 'none', but
@@ -754,7 +754,7 @@
 
 
 
-  +o  None - device=none
+  o  None - device=none
 
 
      This causes the device to disappear.
@@ -785,7 +785,7 @@
 
 
 
-  55..33..  EExxaammpplleess
+  5.3.  Examples
 
   There are a number of interesting things you can do with this
   capability.
@@ -838,7 +838,7 @@
   prompt of the other virtual machine.
 
 
-  66..  SSeettttiinngg uupp tthhee nneettwwoorrkk
+  6.  Setting up the network
 
 
 
@@ -858,19 +858,19 @@
   There are currently five transport types available for a UML virtual
   machine to exchange packets with other hosts:
 
-  +o  ethertap
+  o  ethertap
 
-  +o  TUN/TAP
+  o  TUN/TAP
 
-  +o  Multicast
+  o  Multicast
 
-  +o  a switch daemon
+  o  a switch daemon
 
-  +o  slip
+  o  slip
 
-  +o  slirp
+  o  slirp
 
-  +o  pcap
+  o  pcap
 
      The TUN/TAP, ethertap, slip, and slirp transports allow a UML
      instance to exchange packets with the host.  They may be directed
@@ -893,28 +893,28 @@
   With so many host transports, which one should you use?  Here's when
   you should use each one:
 
-  +o  ethertap - if you want access to the host networking and it is
+  o  ethertap - if you want access to the host networking and it is
      running 2.2
 
-  +o  TUN/TAP - if you want access to the host networking and it is
+  o  TUN/TAP - if you want access to the host networking and it is
      running 2.4.  Also, the TUN/TAP transport is able to use a
      preconfigured device, allowing it to avoid using the setuid uml_net
      helper, which is a security advantage.
 
-  +o  Multicast - if you want a purely virtual network and you don't want
+  o  Multicast - if you want a purely virtual network and you don't want
      to set up anything but the UML
 
-  +o  a switch daemon - if you want a purely virtual network and you
+  o  a switch daemon - if you want a purely virtual network and you
      don't mind running the daemon in order to get somewhat better
      performance
 
-  +o  slip - there is no particular reason to run the slip backend unless
+  o  slip - there is no particular reason to run the slip backend unless
      ethertap and TUN/TAP are just not available for some reason
 
-  +o  slirp - if you don't have root access on the host to setup
+  o  slirp - if you don't have root access on the host to setup
      networking, or if you don't want to allocate an IP to your UML
 
-  +o  pcap - not much use for actual network connectivity, but great for
+  o  pcap - not much use for actual network connectivity, but great for
      monitoring traffic on the host
 
      Ethertap is available on 2.4 and works fine.  TUN/TAP is preferred
@@ -926,7 +926,7 @@
      exploit the helper's root privileges.
 
 
-  66..11..  GGeenneerraall sseettuupp
+  6.1.  General setup
 
   First, you must have the virtual network enabled in your UML.  If are
   running a prebuilt kernel from this site, everything is already
@@ -995,7 +995,7 @@
 
 
 
-  66..22..  UUsseerrssppaaccee ddaaeemmoonnss
+  6.2.  Userspace daemons
 
   You will likely need the setuid helper, or the switch daemon, or both.
   They are both installed with the RPM and deb, so if you've installed
@@ -1011,7 +1011,7 @@
 
 
 
-  66..33..  SSppeecciiffyyiinngg eetthheerrnneett aaddddrreesssseess
+  6.3.  Specifying ethernet addresses
 
   Below, you will see that the TUN/TAP, ethertap, and daemon interfaces
   allow you to specify hardware addresses for the virtual ethernet
@@ -1023,11 +1023,11 @@
   sufficient to guarantee a unique hardware address for the device.  A
   couple of exceptions are:
 
-  +o  Another set of virtual ethernet devices are on the same network and
+  o  Another set of virtual ethernet devices are on the same network and
      they are assigned hardware addresses using a different scheme which
      may conflict with the UML IP address-based scheme
 
-  +o  You aren't going to use the device for IP networking, so you don't
+  o  You aren't going to use the device for IP networking, so you don't
      assign the device an IP address
 
      If you let the driver provide the hardware address, you should make
@@ -1049,7 +1049,7 @@
 
 
 
-  66..44..  UUMMLL iinntteerrffaaccee sseettuupp
+  6.4.  UML interface setup
 
   Once the network devices have been described on the command line, you
   should boot UML and log in.
@@ -1131,7 +1131,7 @@
 
 
 
-  66..55..  MMuullttiiccaasstt
+  6.5.  Multicast
 
   The simplest way to set up a virtual network between multiple UMLs is
   to use the mcast transport.  This was written by Harald Welte and is
@@ -1194,7 +1194,7 @@
 
 
 
-  66..66..  TTUUNN//TTAAPP wwiitthh tthhee uummll__nneett hheellppeerr
+  6.6.  TUN/TAP with the uml_net helper
 
   TUN/TAP is the preferred mechanism on 2.4 to exchange packets with the
   host.  The TUN/TAP backend has been in UML since 2.4.9-3um.
@@ -1247,10 +1247,10 @@
   There are a couple potential problems with running the TUN/TAP
   transport on a 2.4 host kernel
 
-  +o  TUN/TAP seems not to work on 2.4.3 and earlier.  Upgrade the host
+  o  TUN/TAP seems not to work on 2.4.3 and earlier.  Upgrade the host
      kernel or use the ethertap transport.
 
-  +o  With an upgraded kernel, TUN/TAP may fail with
+  o  With an upgraded kernel, TUN/TAP may fail with
 
 
        File descriptor in bad state
@@ -1269,7 +1269,7 @@
 
 
 
-  66..77..  TTUUNN//TTAAPP wwiitthh aa pprreeccoonnffiigguurreedd ttaapp ddeevviiccee
+  6.7.  TUN/TAP with a preconfigured tap device
 
   If you prefer not to have UML use uml_net (which is somewhat
   insecure), with UML 2.4.17-11, you can set up a TUN/TAP device
@@ -1277,7 +1277,7 @@
   there is no need for root assistance.  Setting up the device is done
   as follows:
 
-  +o  Create the device with tunctl (available from the UML utilities
+  o  Create the device with tunctl (available from the UML utilities
      tarball)
 
 
@@ -1291,7 +1291,7 @@
   where uid is the user id or username that UML will be run as.  This
   will tell you what device was created.
 
-  +o  Configure the device IP (change IP addresses and device name to
+  o  Configure the device IP (change IP addresses and device name to
      suit)
 
 
@@ -1303,7 +1303,7 @@
 
 
 
-  +o  Set up routing and arping if desired - this is my recipe, there are
+  o  Set up routing and arping if desired - this is my recipe, there are
      other ways of doing the same thing
 
 
@@ -1338,7 +1338,7 @@
   utility which reads the information from a config file and sets up
   devices at boot time.
 
-  +o  Rather than using up two IPs and ARPing for one of them, you can
+  o  Rather than using up two IPs and ARPing for one of them, you can
      also provide direct access to your LAN by the UML by using a
      bridge.
 
@@ -1417,7 +1417,7 @@
   Note that 'br0' should be setup using ifconfig with the existing IP
   address of eth0, as eth0 no longer has its own IP.
 
-  +o
+  o
 
 
      Also, the /dev/net/tun device must be writable by the user running
@@ -1438,11 +1438,11 @@
   devices and chgrp /dev/net/tun to that group with mode 664 or 660.
 
 
-  +o  Once the device is set up, run UML with 'eth0=tuntap,device name'
+  o  Once the device is set up, run UML with 'eth0=tuntap,device name'
      (i.e. 'eth0=tuntap,tap0') on the command line (or do it with the
      mconsole config command).
 
-  +o  Bring the eth device up in UML and you're in business.
+  o  Bring the eth device up in UML and you're in business.
 
      If you don't want that tap device any more, you can make it non-
      persistent with
@@ -1465,7 +1465,7 @@
 
 
 
-  66..88..  EEtthheerrttaapp
+  6.8.  Ethertap
 
   Ethertap is the general mechanism on 2.2 for userspace processes to
   exchange packets with the kernel.
@@ -1561,9 +1561,9 @@
 
 
 
-  66..99..  TThhee sswwiittcchh ddaaeemmoonn
+  6.9.  The switch daemon
 
-  NNoottee: This is the daemon formerly known as uml_router, but which was
+  Note: This is the daemon formerly known as uml_router, but which was
   renamed so the network weenies of the world would stop growling at me.
 
 
@@ -1649,7 +1649,7 @@
 
 
 
-  66..1100..  SSlliipp
+  6.10.  Slip
 
   Slip is another, less general, mechanism for a process to communicate
   with the host networking.  In contrast to the ethertap interface,
@@ -1681,7 +1681,7 @@
 
 
 
-  66..1111..  SSlliirrpp
+  6.11.  Slirp
 
   slirp uses an external program, usually /usr/bin/slirp, to provide IP
   only networking connectivity through the host. This is similar to IP
@@ -1737,7 +1737,7 @@
 
 
 
-  66..1122..  ppccaapp
+  6.12.  pcap
 
   The pcap transport is attached to a UML ethernet device on the command
   line or with uml_mconsole with the following syntax:
@@ -1777,7 +1777,7 @@
 
 
 
-  66..1133..  SSeettttiinngg uupp tthhee hhoosstt yyoouurrsseellff
+  6.13.  Setting up the host yourself
 
   If you don't specify an address for the host side of the ethertap or
   slip device, UML won't do any setup on the host.  So this is what is
@@ -1785,7 +1785,7 @@
   192.168.0.251 and a UML-side IP of 192.168.0.250 - adjust to suit your
   own network):
 
-  +o  The device needs to be configured with its IP address.  Tap devices
+  o  The device needs to be configured with its IP address.  Tap devices
      are also configured with an mtu of 1484.  Slip devices are
      configured with a point-to-point address pointing at the UML ip
      address.
@@ -1805,7 +1805,7 @@
 
 
 
-  +o  If a tap device is being set up, a route is set to the UML IP.
+  o  If a tap device is being set up, a route is set to the UML IP.
 
 
        UML# route add -host 192.168.0.250 gw 192.168.0.251
@@ -1814,7 +1814,7 @@
 
 
 
-  +o  To allow other hosts on your network to see the virtual machine,
+  o  To allow other hosts on your network to see the virtual machine,
      proxy arp is set up for it.
 
 
@@ -1824,7 +1824,7 @@
 
 
 
-  +o  Finally, the host is set up to route packets.
+  o  Finally, the host is set up to route packets.
 
 
        host#  echo 1 > /proc/sys/net/ipv4/ip_forward
@@ -1838,12 +1838,12 @@
 
 
 
-  77..  SShhaarriinngg FFiilleessyysstteemmss bbeettwweeeenn VViirrttuuaall MMaacchhiinneess
+  7.  Sharing Filesystems between Virtual Machines
 
 
 
 
-  77..11..  AA wwaarrnniinngg
+  7.1.  A warning
 
   Don't attempt to share filesystems simply by booting two UMLs from the
   same file.  That's the same thing as booting two physical machines
@@ -1851,7 +1851,7 @@
 
 
 
-  77..22..  UUssiinngg llaayyeerreedd bblloocckk ddeevviicceess
+  7.2.  Using layered block devices
 
   The way to share a filesystem between two virtual machines is to use
   the copy-on-write (COW) layering capability of the ubd block driver.
@@ -1896,7 +1896,7 @@
 
 
 
-  77..33..  NNoottee!!
+  7.3.  Note!
 
   When checking the size of the COW file in order to see the gobs of
   space that you're saving, make sure you use 'ls -ls' to see the actual
@@ -1926,7 +1926,7 @@
 
 
 
-  77..44..  AAnnootthheerr wwaarrnniinngg
+  7.4.  Another warning
 
   Once a filesystem is being used as a readonly backing file for a COW
   file, do not boot directly from it or modify it in any way.  Doing so
@@ -1952,7 +1952,7 @@
 
 
 
-  77..55..  uummll__mmoooo :: MMeerrggiinngg aa CCOOWW ffiillee wwiitthh iittss bbaacckkiinngg ffiillee
+  7.5.  uml_moo : Merging a COW file with its backing file
 
   Depending on how you use UML and COW devices, it may be advisable to
   merge the changes in the COW file into the backing file every once in
@@ -2001,7 +2001,7 @@
 
 
 
-  88..  CCrreeaattiinngg ffiilleessyysstteemmss
+  8.  Creating filesystems
 
 
   You may want to create and mount new UML filesystems, either because
@@ -2015,7 +2015,7 @@
   should be easy to translate to the filesystem of your choice.
 
 
-  88..11..  CCrreeaattee tthhee ffiilleessyysstteemm ffiillee
+  8.1.  Create the filesystem file
 
   dd is your friend.  All you need to do is tell dd to create an empty
   file of the appropriate size.  I usually make it sparse to save time
@@ -2032,7 +2032,7 @@
 
 
 
-  88..22..  AAssssiiggnn tthhee ffiillee ttoo aa UUMMLL ddeevviiccee
+  8.2.  Assign the file to a UML device
 
   Add an argument like the following to the UML command line:
 
@@ -2045,7 +2045,7 @@
 
 
 
-  88..33..  CCrreeaattiinngg aanndd mmoouunnttiinngg tthhee ffiilleessyysstteemm
+  8.3.  Creating and mounting the filesystem
 
   Make sure that the filesystem is available, either by being built into
   the kernel, or available as a module, then boot up UML and log in.  If
@@ -2096,7 +2096,7 @@
 
 
 
-  99..  HHoosstt ffiillee aacccceessss
+  9.  Host file access
 
 
   If you want to access files on the host machine from inside UML, you
@@ -2112,7 +2112,7 @@
   files contained in it just as you would on the host.
 
 
-  99..11..  UUssiinngg hhoossttffss
+  9.1.  Using hostfs
 
   To begin with, make sure that hostfs is available inside the virtual
   machine with
@@ -2151,7 +2151,7 @@
 
 
 
-  99..22..  hhoossttffss aass tthhee rroooott ffiilleessyysstteemm
+  9.2.  hostfs as the root filesystem
 
   It's possible to boot from a directory hierarchy on the host using
   hostfs rather than using the standard filesystem in a file.
@@ -2194,20 +2194,20 @@
   UML should then boot as it does normally.
 
 
-  99..33..  BBuuiillddiinngg hhoossttffss
+  9.3.  Building hostfs
 
   If you need to build hostfs because it's not in your kernel, you have
   two choices:
 
 
 
-  +o  Compiling hostfs into the kernel:
+  o  Compiling hostfs into the kernel:
 
 
      Reconfigure the kernel and set the 'Host filesystem' option under
 
 
-  +o  Compiling hostfs as a module:
+  o  Compiling hostfs as a module:
 
 
      Reconfigure the kernel and set the 'Host filesystem' option under
@@ -2228,7 +2228,7 @@
 
 
 
-  1100..  TThhee MMaannaaggeemmeenntt CCoonnssoollee
+  10.  The Management Console
 
 
 
@@ -2240,15 +2240,15 @@
 
   There are a number of things you can do with the mconsole interface:
 
-  +o  get the kernel version
+  o  get the kernel version
 
-  +o  add and remove devices
+  o  add and remove devices
 
-  +o  halt or reboot the machine
+  o  halt or reboot the machine
 
-  +o  Send SysRq commands
+  o  Send SysRq commands
 
-  +o  Pause and resume the UML
+  o  Pause and resume the UML
 
 
   You need the mconsole client (uml_mconsole) which is present in CVS
@@ -2300,28 +2300,28 @@
 
   You'll get a prompt, at which you can run one of these commands:
 
-  +o  version
+  o  version
 
-  +o  halt
+  o  halt
 
-  +o  reboot
+  o  reboot
 
-  +o  config
+  o  config
 
-  +o  remove
+  o  remove
 
-  +o  sysrq
+  o  sysrq
 
-  +o  help
+  o  help
 
-  +o  cad
+  o  cad
 
-  +o  stop
+  o  stop
 
-  +o  go
+  o  go
 
 
-  1100..11..  vveerrssiioonn
+  10.1.  version
 
   This takes no arguments.  It prints the UML version.
 
@@ -2342,7 +2342,7 @@
 
 
 
-  1100..22..  hhaalltt aanndd rreebboooott
+  10.2.  halt and reboot
 
   These take no arguments.  They shut the machine down immediately, with
   no syncing of disks and no clean shutdown of userspace.  So, they are
@@ -2357,7 +2357,7 @@
 
 
 
-  1100..33..  ccoonnffiigg
+  10.3.  config
 
   "config" adds a new device to the virtual machine.  Currently the ubd
   and network drivers support this.  It takes one argument, which is the
@@ -2378,7 +2378,7 @@
 
 
 
-  1100..44..  rreemmoovvee
+  10.4.  remove
 
   "remove" deletes a device from the system.  Its argument is just the
   name of the device to be removed. The device must be idle in whatever
@@ -2397,7 +2397,7 @@
 
 
 
-  1100..55..  ssyyssrrqq
+  10.5.  sysrq
 
   This takes one argument, which is a single letter.  It calls the
   generic kernel's SysRq driver, which does whatever is called for by
@@ -2407,14 +2407,14 @@
 
 
 
-  1100..66..  hheellpp
+  10.6.  help
 
   "help" returns a string listing the valid commands and what each one
   does.
 
 
 
-  1100..77..  ccaadd
+  10.7.  cad
 
   This invokes the Ctl-Alt-Del action on init.  What exactly this ends
   up doing is up to /etc/inittab.  Normally, it reboots the machine.
@@ -2432,7 +2432,7 @@
 
 
 
-  1100..88..  ssttoopp
+  10.8.  stop
 
   This puts the UML in a loop reading mconsole requests until a 'go'
   mconsole command is received. This is very useful for making backups
@@ -2448,7 +2448,7 @@
 
 
 
-  1100..99..  ggoo
+  10.9.  go
 
   This resumes a UML after being paused by a 'stop' command. Note that
   when the UML has resumed, TCP connections may have timed out and if
@@ -2462,10 +2462,10 @@
 
 
 
-  1111..  KKeerrnneell ddeebbuuggggiinngg
+  11.  Kernel debugging
 
 
-  NNoottee:: The interface that makes debugging, as described here, possible
+  Note: The interface that makes debugging, as described here, possible
   is present in 2.4.0-test6 kernels and later.
 
 
@@ -2485,7 +2485,7 @@
 
 
 
-  1111..11..  SSttaarrttiinngg tthhee kkeerrnneell uunnddeerr ggddbb
+  11.1.  Starting the kernel under gdb
 
   You can have the kernel running under the control of gdb from the
   beginning by putting 'debug' on the command line.  You will get an
@@ -2498,7 +2498,7 @@
   There is a transcript of a debugging session  here <debug-
   session.html> , with breakpoints being set in the scheduler and in an
   interrupt handler.
-  1111..22..  EExxaammiinniinngg sslleeeeppiinngg pprroocceesssseess
+  11.2.  Examining sleeping processes
 
   Not every bug is evident in the currently running process.  Sometimes,
   processes hang in the kernel when they shouldn't because they've
@@ -2516,7 +2516,7 @@
 
   Now what you do is this:
 
-  +o  detach from the current thread
+  o  detach from the current thread
 
 
        (UML gdb)  det
@@ -2525,7 +2525,7 @@
 
 
 
-  +o  attach to the thread you are interested in
+  o  attach to the thread you are interested in
 
 
        (UML gdb)  att <host pid>
@@ -2534,7 +2534,7 @@
 
 
 
-  +o  look at its stack and anything else of interest
+  o  look at its stack and anything else of interest
 
 
        (UML gdb)  bt
@@ -2545,7 +2545,7 @@
   Note that you can't do anything at this point that requires that a
   process execute, e.g. calling a function
 
-  +o  when you're done looking at that process, reattach to the current
+  o  when you're done looking at that process, reattach to the current
      thread and continue it
 
 
@@ -2569,12 +2569,12 @@
 
 
 
-  1111..33..  RRuunnnniinngg dddddd oonn UUMMLL
+  11.3.  Running ddd on UML
 
   ddd works on UML, but requires a special kludge.  The process goes
   like this:
 
-  +o  Start ddd
+  o  Start ddd
 
 
        host% ddd linux
@@ -2583,14 +2583,14 @@
 
 
 
-  +o  With ps, get the pid of the gdb that ddd started.  You can ask the
+  o  With ps, get the pid of the gdb that ddd started.  You can ask the
      gdb to tell you, but for some reason that confuses things and
      causes a hang.
 
-  +o  run UML with 'debug=parent gdb-pid=<pid>' added to the command line
+  o  run UML with 'debug=parent gdb-pid=<pid>' added to the command line
      - it will just sit there after you hit return
 
-  +o  type 'att 1' to the ddd gdb and you will see something like
+  o  type 'att 1' to the ddd gdb and you will see something like
 
 
        0xa013dc51 in __kill ()
@@ -2602,12 +2602,12 @@
 
 
 
-  +o  At this point, type 'c', UML will boot up, and you can use ddd just
+  o  At this point, type 'c', UML will boot up, and you can use ddd just
      as you do on any other process.
 
 
 
-  1111..44..  DDeebbuuggggiinngg mmoodduulleess
+  11.4.  Debugging modules
 
   gdb has support for debugging code which is dynamically loaded into
   the process.  This support is what is needed to debug kernel modules
@@ -2823,7 +2823,7 @@
 
 
 
-  1111..55..  AAttttaacchhiinngg ggddbb ttoo tthhee kkeerrnneell
+  11.5.  Attaching gdb to the kernel
 
   If you don't have the kernel running under gdb, you can attach gdb to
   it later by sending the tracing thread a SIGUSR1.  The first line of
@@ -2857,7 +2857,7 @@
 
 
 
-  1111..66..  UUssiinngg aalltteerrnnaattee ddeebbuuggggeerrss
+  11.6.  Using alternate debuggers
 
   UML has support for attaching to an already running debugger rather
   than starting gdb itself.  This is present in CVS as of 17 Apr 2001.
@@ -2886,7 +2886,7 @@
   An example of an alternate debugger is strace.  You can strace the
   actual kernel as follows:
 
-  +o  Run the following in a shell
+  o  Run the following in a shell
 
 
        host%
@@ -2894,10 +2894,10 @@
 
 
 
-  +o  Run UML with 'debug' and 'gdb-pid=<pid>' with the pid printed out
+  o  Run UML with 'debug' and 'gdb-pid=<pid>' with the pid printed out
      by the previous command
 
-  +o  Hit return in the shell, and UML will start running, and strace
+  o  Hit return in the shell, and UML will start running, and strace
      output will start accumulating in the output file.
 
      Note that this is different from running
@@ -2917,9 +2917,9 @@
 
 
 
-  1122..  KKeerrnneell ddeebbuuggggiinngg eexxaammpplleess
+  12.  Kernel debugging examples
 
-  1122..11..  TThhee ccaassee ooff tthhee hhuunngg ffsscckk
+  12.1.  The case of the hung fsck
 
   When booting up the kernel, fsck failed, and dropped me into a shell
   to fix things up.  I ran fsck -y, which hung:
@@ -3154,9 +3154,9 @@
 
   The interesting things here are :
 
-  +o  There are two segfaults on this stack (frames 9 and 14)
+  o  There are two segfaults on this stack (frames 9 and 14)
 
-  +o  The first faulting address (frame 11) is 0x50000800
+  o  The first faulting address (frame 11) is 0x50000800
 
   (gdb) p (void *)1342179328
   $16 = (void *) 0x50000800
@@ -3399,7 +3399,7 @@
   on will be somewhat clearer.
 
 
-  1122..22..  EEppiissooddee 22:: TThhee ccaassee ooff tthhee hhuunngg ffsscckk
+  12.2.  Episode 2: The case of the hung fsck
 
   After setting a trap in the SEGV handler for accesses to the signal
   thread's stack, I reran the kernel.
@@ -3788,12 +3788,12 @@
 
 
 
-  1133..  WWhhaatt ttoo ddoo wwhheenn UUMMLL ddooeessnn''tt wwoorrkk
+  13.  What to do when UML doesn't work
 
 
 
 
-  1133..11..  SSttrraannggee ccoommppiillaattiioonn eerrrroorrss wwhheenn yyoouu bbuuiilldd ffrroomm ssoouurrccee
+  13.1.  Strange compilation errors when you build from source
 
   As of test11, it is necessary to have "ARCH=um" in the environment or
   on the make command line for all steps in building UML, including
@@ -3824,8 +3824,8 @@
 
 
 
-  1133..33..  AA vvaarriieettyy ooff ppaanniiccss aanndd hhaannggss wwiitthh //ttmmpp oonn aa rreeiisseerrffss  ffiilleessyyss--
-  tteemm
+  13.3.  A variety of panics and hangs with /tmp on a reiserfs  filesys-
+  tem
 
   I saw this on reiserfs 3.5.21 and it seems to be fixed in 3.5.27.
   Panics preceded by
@@ -3842,8 +3842,8 @@
 
 
 
-  1133..44..  TThhee ccoommppiillee ffaaiillss wwiitthh eerrrroorrss aabboouutt ccoonnfflliiccttiinngg ttyyppeess ffoorr
-  ''ooppeenn'',, ''dduupp'',, aanndd ''wwaaiittppiidd''
+  13.4.  The compile fails with errors about conflicting types for
+  'open', 'dup', and 'waitpid'
 
   This happens when you build in /usr/src/linux.  The UML build makes
   the include/asm link point to include/asm-um.  /usr/include/asm points
@@ -3854,14 +3854,14 @@
 
 
 
-  1133..55..  UUMMLL ddooeessnn''tt wwoorrkk wwhheenn //ttmmpp iiss aann NNFFSS ffiilleessyysstteemm
+  13.5.  UML doesn't work when /tmp is an NFS filesystem
 
   This seems to be a similar situation with the ReiserFS problem above.
   Some versions of NFS seems not to handle mmap correctly, which UML
   depends on.  The workaround is have /tmp be a non-NFS directory.
 
 
-  1133..66..  UUMMLL hhaannggss oonn bboooott wwhheenn ccoommppiilleedd wwiitthh ggpprrooff ssuuppppoorrtt
+  13.6.  UML hangs on boot when compiled with gprof support
 
   If you build UML with gprof support and, early in the boot, it does
   this
@@ -3878,7 +3878,7 @@
 
 
 
-  1133..77..  ssyyssllooggdd ddiieess wwiitthh aa SSIIGGTTEERRMM oonn ssttaarrttuupp
+  13.7.  syslogd dies with a SIGTERM on startup
 
   The exact boot error depends on the distribution that you're booting,
   but Debian produces this:
@@ -3897,17 +3897,17 @@
 
 
 
-  1133..88..  TTUUNN//TTAAPP nneettwwoorrkkiinngg ddooeessnn''tt wwoorrkk oonn aa 22..44 hhoosstt
+  13.8.  TUN/TAP networking doesn't work on a 2.4 host
 
   There are a couple of problems which were
   <http://www.geocrawler.com/lists/3/SourceForge/597/0/> name="pointed
   out">  by Tim Robinson <timro at trkr dot net>
 
-  +o  It doesn't work on hosts running 2.4.7 (or thereabouts) or earlier.
+  o  It doesn't work on hosts running 2.4.7 (or thereabouts) or earlier.
      The fix is to upgrade to something more recent and then read the
      next item.
 
-  +o  If you see
+  o  If you see
 
 
        File descriptor in bad state
@@ -3921,8 +3921,8 @@
 
 
 
-  1133..99..  YYoouu ccaann nneettwwoorrkk ttoo tthhee hhoosstt bbuutt nnoott ttoo ootthheerr mmaacchhiinneess oonn tthhee
-  nneett
+  13.9.  You can network to the host but not to other machines on the
+  net
 
   If you can connect to the host, and the host can connect to UML, but
   you cannot connect to any other machines, then you may need to enable
@@ -3972,7 +3972,7 @@
 
 
 
-  1133..1100..  II hhaavvee nnoo rroooott aanndd II wwaanntt ttoo ssccrreeaamm
+  13.10.  I have no root and I want to scream
 
   Thanks to Birgit Wahlich for telling me about this strange one.  It
   turns out that there's a limit of six environment variables on the
@@ -3987,7 +3987,7 @@
 
 
 
-  1133..1111..  UUMMLL bbuuiilldd ccoonnfflliicctt bbeettwweeeenn ppttrraaccee..hh aanndd uuccoonntteexxtt..hh
+  13.11.  UML build conflict between ptrace.h and ucontext.h
 
   On some older systems, /usr/include/asm/ptrace.h and
   /usr/include/sys/ucontext.h define the same names.  So, when they're
@@ -4007,7 +4007,7 @@
 
 
 
-  1133..1122..  TThhee UUMMLL BBooggooMMiippss iiss eexxaaccttllyy hhaallff tthhee hhoosstt''ss BBooggooMMiippss
+  13.12.  The UML BogoMips is exactly half the host's BogoMips
 
   On i386 kernels, there are two ways of running the loop that is used
   to calculate the BogoMips rating, using the TSC if it's there or using
@@ -4019,7 +4019,7 @@
 
 
 
-  1133..1133..  WWhheenn yyoouu rruunn UUMMLL,, iitt iimmmmeeddiiaatteellyy sseeggffaauullttss
+  13.13.  When you run UML, it immediately segfaults
 
   If the host is configured with the 2G/2G address space split, that's
   why.  See ``UML on 2G/2G hosts''  for the details on getting UML to
@@ -4027,7 +4027,7 @@
 
 
 
-  1133..1144..  xxtteerrmmss aappppeeaarr,, tthheenn iimmmmeeddiiaatteellyy ddiissaappppeeaarr
+  13.14.  xterms appear, then immediately disappear
 
   If you're running an up to date kernel with an old release of
   uml_utilities, the port-helper program will not work properly, so
@@ -4039,7 +4039,7 @@
 
 
 
-  1133..1155..  AAnnyy ootthheerr ppaanniicc,, hhaanngg,, oorr ssttrraannggee bbeehhaavviioorr
+  13.15.  Any other panic, hang, or strange behavior
 
   If you're seeing truly strange behavior, such as hangs or panics that
   happen in random places, or you try running the debugger to see what's
@@ -4059,7 +4059,7 @@
 
   If you want to be super-helpful, read ``Diagnosing Problems'' and
   follow the instructions contained therein.
-  1144..  DDiiaaggnnoossiinngg PPrroobblleemmss
+  14.  Diagnosing Problems
 
 
   If you get UML to crash, hang, or otherwise misbehave, you should
@@ -4078,7 +4078,7 @@
   ``Kernel debugging''  UML first.
 
 
-  1144..11..  CCaassee 11 :: NNoorrmmaall kkeerrnneell ppaanniiccss
+  14.1.  Case 1 : Normal kernel panics
 
   The most common case is for a normal thread to panic.  To debug this,
   you will need to run it under the debugger (add 'debug' to the command
@@ -4128,7 +4128,7 @@
   to get that information from the faulting ip.
 
 
-  1144..22..  CCaassee 22 :: TTrraacciinngg tthhrreeaadd ppaanniiccss
+  14.2.  Case 2 : Tracing thread panics
 
   The less common and more painful case is when the tracing thread
   panics.  In this case, the kernel debugger will be useless because it
@@ -4161,7 +4161,7 @@
   backtrace in and wait for our crack debugging team to fix the problem.
 
 
-  1144..33..  CCaassee 33 :: TTrraacciinngg tthhrreeaadd ppaanniiccss ccaauusseedd bbyy ootthheerr tthhrreeaaddss
+  14.3.  Case 3 : Tracing thread panics caused by other threads
 
   However, there are cases where the misbehavior of another thread
   caused the problem.  The most common panic of this type is:
@@ -4227,7 +4227,7 @@
 
 
 
-  1144..44..  CCaassee 44 :: HHaannggss
+  14.4.  Case 4 : Hangs
 
   Hangs seem to be fairly rare, but they sometimes happen.  When a hang
   happens, we need a backtrace from the offending process.  Run the
@@ -4257,7 +4257,7 @@
 
 
 
-  1155..  TThhaannkkss
+  15.  Thanks
 
 
   A number of people have helped this project in various ways, and this
@@ -4274,20 +4274,20 @@
   bookkeeping lapses and I forget about contributions.
 
 
-  1155..11..  CCooddee aanndd DDooccuummeennttaattiioonn
+  15.1.  Code and Documentation
 
   Rusty Russell <rusty at linuxcare.com.au>  -
 
-  +o  wrote the  HOWTO <http://user-mode-
+  o  wrote the  HOWTO <http://user-mode-
      linux.sourceforge.net/UserModeLinux-HOWTO.html>
 
-  +o  prodded me into making this project official and putting it on
+  o  prodded me into making this project official and putting it on
      SourceForge
 
-  +o  came up with the way cool UML logo <http://user-mode-
+  o  came up with the way cool UML logo <http://user-mode-
      linux.sourceforge.net/uml-small.png>
 
-  +o  redid the config process
+  o  redid the config process
 
 
   Peter Moulder <reiter at netspace.net.au>  - Fixed my config and build
@@ -4296,18 +4296,18 @@
 
   Bill Stearns <wstearns at pobox.com>  -
 
-  +o  HOWTO updates
+  o  HOWTO updates
 
-  +o  lots of bug reports
+  o  lots of bug reports
 
-  +o  lots of testing
+  o  lots of testing
 
-  +o  dedicated a box (uml.ists.dartmouth.edu) to support UML development
+  o  dedicated a box (uml.ists.dartmouth.edu) to support UML development
 
-  +o  wrote the mkrootfs script, which allows bootable filesystems of
+  o  wrote the mkrootfs script, which allows bootable filesystems of
      RPM-based distributions to be cranked out
 
-  +o  cranked out a large number of filesystems with said script
+  o  cranked out a large number of filesystems with said script
 
 
   Jim Leu <jleu at mindspring.com>  - Wrote the virtual ethernet driver
@@ -4375,176 +4375,176 @@
 
   David Coulson <http://davidcoulson.net>  -
 
-  +o  Set up the usermodelinux.org <http://usermodelinux.org>  site,
+  o  Set up the usermodelinux.org <http://usermodelinux.org>  site,
      which is a great way of keeping the UML user community on top of
      UML goings-on.
 
-  +o  Site documentation and updates
+  o  Site documentation and updates
 
-  +o  Nifty little UML management daemon  UMLd
+  o  Nifty little UML management daemon  UMLd
      <http://uml.openconsultancy.com/umld/>
 
-  +o  Lots of testing and bug reports
+  o  Lots of testing and bug reports
 
 
 
 
-  1155..22..  FFlluusshhiinngg oouutt bbuuggss
+  15.2.  Flushing out bugs
 
 
 
-  +o  Yuri Pudgorodsky
+  o  Yuri Pudgorodsky
 
-  +o  Gerald Britton
+  o  Gerald Britton
 
-  +o  Ian Wehrman
+  o  Ian Wehrman
 
-  +o  Gord Lamb
+  o  Gord Lamb
 
-  +o  Eugene Koontz
+  o  Eugene Koontz
 
-  +o  John H. Hartman
+  o  John H. Hartman
 
-  +o  Anders Karlsson
+  o  Anders Karlsson
 
-  +o  Daniel Phillips
+  o  Daniel Phillips
 
-  +o  John Fremlin
+  o  John Fremlin
 
-  +o  Rainer Burgstaller
+  o  Rainer Burgstaller
 
-  +o  James Stevenson
+  o  James Stevenson
 
-  +o  Matt Clay
+  o  Matt Clay
 
-  +o  Cliff Jefferies
+  o  Cliff Jefferies
 
-  +o  Geoff Hoff
+  o  Geoff Hoff
 
-  +o  Lennert Buytenhek
+  o  Lennert Buytenhek
 
-  +o  Al Viro
+  o  Al Viro
 
-  +o  Frank Klingenhoefer
+  o  Frank Klingenhoefer
 
-  +o  Livio Baldini Soares
+  o  Livio Baldini Soares
 
-  +o  Jon Burgess
+  o  Jon Burgess
 
-  +o  Petru Paler
+  o  Petru Paler
 
-  +o  Paul
+  o  Paul
 
-  +o  Chris Reahard
+  o  Chris Reahard
 
-  +o  Sverker Nilsson
+  o  Sverker Nilsson
 
-  +o  Gong Su
+  o  Gong Su
 
-  +o  johan verrept
+  o  johan verrept
 
-  +o  Bjorn Eriksson
+  o  Bjorn Eriksson
 
-  +o  Lorenzo Allegrucci
+  o  Lorenzo Allegrucci
 
-  +o  Muli Ben-Yehuda
+  o  Muli Ben-Yehuda
 
-  +o  David Mansfield
+  o  David Mansfield
 
-  +o  Howard Goff
+  o  Howard Goff
 
-  +o  Mike Anderson
+  o  Mike Anderson
 
-  +o  John Byrne
+  o  John Byrne
 
-  +o  Sapan J. Batia
+  o  Sapan J. Batia
 
-  +o  Iris Huang
+  o  Iris Huang
 
-  +o  Jan Hudec
+  o  Jan Hudec
 
-  +o  Voluspa
+  o  Voluspa
 
 
 
 
-  1155..33..  BBuugglleettss aanndd cclleeaann--uuppss
+  15.3.  Buglets and clean-ups
 
 
 
-  +o  Dave Zarzycki
+  o  Dave Zarzycki
 
-  +o  Adam Lazur
+  o  Adam Lazur
 
-  +o  Boria Feigin
+  o  Boria Feigin
 
-  +o  Brian J. Murrell
+  o  Brian J. Murrell
 
-  +o  JS
+  o  JS
 
-  +o  Roman Zippel
+  o  Roman Zippel
 
-  +o  Wil Cooley
+  o  Wil Cooley
 
-  +o  Ayelet Shemesh
+  o  Ayelet Shemesh
 
-  +o  Will Dyson
+  o  Will Dyson
 
-  +o  Sverker Nilsson
+  o  Sverker Nilsson
 
-  +o  dvorak
+  o  dvorak
 
-  +o  v.naga srinivas
+  o  v.naga srinivas
 
-  +o  Shlomi Fish
+  o  Shlomi Fish
 
-  +o  Roger Binns
+  o  Roger Binns
 
-  +o  johan verrept
+  o  johan verrept
 
-  +o  MrChuoi
+  o  MrChuoi
 
-  +o  Peter Cleve
+  o  Peter Cleve
 
-  +o  Vincent Guffens
+  o  Vincent Guffens
 
-  +o  Nathan Scott
+  o  Nathan Scott
 
-  +o  Patrick Caulfield
+  o  Patrick Caulfield
 
-  +o  jbearce
+  o  jbearce
 
-  +o  Catalin Marinas
+  o  Catalin Marinas
 
-  +o  Shane Spencer
+  o  Shane Spencer
 
-  +o  Zou Min
+  o  Zou Min
 
 
-  +o  Ryan Boder
+  o  Ryan Boder
 
-  +o  Lorenzo Colitti
+  o  Lorenzo Colitti
 
-  +o  Gwendal Grignou
+  o  Gwendal Grignou
 
-  +o  Andre' Breiler
+  o  Andre' Breiler
 
-  +o  Tsutomu Yasuda
+  o  Tsutomu Yasuda
 
 
 
-  1155..44..  CCaassee SSttuuddiieess
+  15.4.  Case Studies
 
 
-  +o  Jon Wright
+  o  Jon Wright
 
-  +o  William McEwan
+  o  William McEwan
 
-  +o  Michael Richardson
+  o  Michael Richardson
 
 
 
-  1155..55..  OOtthheerr ccoonnttrriibbuuttiioonnss
+  15.5.  Other contributions
 
 
   Bill Carr <Bill.Carr at compaq.com>  made the Red Hat mkrootfs script
-- 
1.7.5.4

