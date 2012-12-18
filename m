Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754772Ab2LRMp5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 07:45:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5955 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754317Ab2LRMpz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 07:45:55 -0500
From: Michal Privoznik <mprivozn@redhat.com>
To: linux-doc@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org
Subject: [PATCH] docs: Kill spaces at EOL in tuntap.txt
Date: Tue, 18 Dec 2012 13:45:41 +0100
Message-Id: <95bca46cc733643dd23d9c1ad260a9ef6589435b.1355834470.git.mprivozn@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whitespace at the end of line is not end of the world,
but nor useful too.

Signed-off-by: Michal Privoznik <mprivozn@redhat.com>
---
 Documentation/networking/tuntap.txt | 64 ++++++++++++++++++-------------------
 1 file changed, 32 insertions(+), 32 deletions(-)

diff --git a/Documentation/networking/tuntap.txt b/Documentation/networking/tuntap.txt
index c0aab98..e1faec9 100644
--- a/Documentation/networking/tuntap.txt
+++ b/Documentation/networking/tuntap.txt
@@ -1,20 +1,20 @@
 Universal TUN/TAP device driver.
 Copyright (C) 1999-2000 Maxim Krasnyansky <max_mk@yahoo.com>
 
-  Linux, Solaris drivers 
+  Linux, Solaris drivers
   Copyright (C) 1999-2000 Maxim Krasnyansky <max_mk@yahoo.com>
 
-  FreeBSD TAP driver 
+  FreeBSD TAP driver
   Copyright (c) 1999-2000 Maksim Yevmenkin <m_evmenkin@yahoo.com>
 
   Revision of this document 2002 by Florian Thiel <florian.thiel@gmx.net>
 
 1. Description
-  TUN/TAP provides packet reception and transmission for user space programs. 
+  TUN/TAP provides packet reception and transmission for user space programs.
   It can be seen as a simple Point-to-Point or Ethernet device, which,
-  instead of receiving packets from physical media, receives them from 
-  user space program and instead of sending packets via physical media 
-  writes them to the user space program. 
+  instead of receiving packets from physical media, receives them from
+  user space program and instead of sending packets via physical media
+  writes them to the user space program.
 
   In order to use the driver a program has to open /dev/net/tun and issue a
   corresponding ioctl() to register a network device with the kernel. A network
@@ -33,17 +33,17 @@ Copyright (C) 1999-2000 Maxim Krasnyansky <max_mk@yahoo.com>
   br_sigio.c  - bridge based on async io and SIGIO signal.
   However, the best example is VTun http://vtun.sourceforge.net :))
 
-2. Configuration 
+2. Configuration
   Create device node:
      mkdir /dev/net (if it doesn't exist already)
      mknod /dev/net/tun c 10 200
-  
+
   Set permissions:
      e.g. chmod 0666 /dev/net/tun
      There's no harm in allowing the device to be accessible by non-root users,
-     since CAP_NET_ADMIN is required for creating network devices or for 
+     since CAP_NET_ADMIN is required for creating network devices or for
      connecting to network devices which aren't owned by the user in question.
-     If you want to create persistent devices and give ownership of them to 
+     If you want to create persistent devices and give ownership of them to
      unprivileged users, then you need the /dev/net/tun device to be usable by
      those users.
 
@@ -52,8 +52,8 @@ Copyright (C) 1999-2000 Maxim Krasnyansky <max_mk@yahoo.com>
      Make sure that "Kernel module loader" - module auto-loading
      support is enabled in your kernel.  The kernel should load it on
      first access.
-  
-  Manual loading 
+
+  Manual loading
      insert the module by hand:
         modprobe tun
 
@@ -61,7 +61,7 @@ Copyright (C) 1999-2000 Maxim Krasnyansky <max_mk@yahoo.com>
   need it, if you do it the other way it will be automatically loaded when
   /dev/net/tun is being opened.
 
-3. Program interface 
+3. Program interface
   3.1 Network device allocation:
 
   char *dev should be the name of the device with a format string (e.g.
@@ -82,12 +82,12 @@ Copyright (C) 1999-2000 Maxim Krasnyansky <max_mk@yahoo.com>
 
       memset(&ifr, 0, sizeof(ifr));
 
-      /* Flags: IFF_TUN   - TUN device (no Ethernet headers) 
-       *        IFF_TAP   - TAP device  
+      /* Flags: IFF_TUN   - TUN device (no Ethernet headers)
+       *        IFF_TAP   - TAP device
        *
-       *        IFF_NO_PI - Do not provide packet information  
-       */ 
-      ifr.ifr_flags = IFF_TUN; 
+       *        IFF_NO_PI - Do not provide packet information
+       */
+      ifr.ifr_flags = IFF_TUN;
       if( *dev )
          strncpy(ifr.ifr_name, dev, IFNAMSIZ);
 
@@ -97,41 +97,41 @@ Copyright (C) 1999-2000 Maxim Krasnyansky <max_mk@yahoo.com>
       }
       strcpy(dev, ifr.ifr_name);
       return fd;
-  }              
- 
+  }
+
   3.2 Frame format:
-  If flag IFF_NO_PI is not set each frame format is: 
+  If flag IFF_NO_PI is not set each frame format is:
      Flags [2 bytes]
      Proto [2 bytes]
      Raw protocol(IP, IPv6, etc) frame.
 
 Universal TUN/TAP device driver Frequently Asked Question.
-   
+
 1. What platforms are supported by TUN/TAP driver ?
 Currently driver has been written for 3 Unices:
-   Linux kernels 2.2.x, 2.4.x 
+   Linux kernels 2.2.x, 2.4.x
    FreeBSD 3.x, 4.x, 5.x
    Solaris 2.6, 7.0, 8.0
 
 2. What is TUN/TAP driver used for?
-As mentioned above, main purpose of TUN/TAP driver is tunneling. 
+As mentioned above, main purpose of TUN/TAP driver is tunneling.
 It is used by VTun (http://vtun.sourceforge.net).
 
 Another interesting application using TUN/TAP is pipsecd
 (http://perso.enst.fr/~beyssac/pipsec/), a userspace IPSec
 implementation that can use complete kernel routing (unlike FreeS/WAN).
 
-3. How does Virtual network device actually work ? 
+3. How does Virtual network device actually work ?
 Virtual network device can be viewed as a simple Point-to-Point or
-Ethernet device, which instead of receiving packets from a physical 
-media, receives them from user space program and instead of sending 
-packets via physical media sends them to the user space program. 
+Ethernet device, which instead of receiving packets from a physical
+media, receives them from user space program and instead of sending
+packets via physical media sends them to the user space program.
 
-Let's say that you configured IPX on the tap0, then whenever 
+Let's say that you configured IPX on the tap0, then whenever
 the kernel sends an IPX packet to tap0, it is passed to the application
-(VTun for example). The application encrypts, compresses and sends it to 
+(VTun for example). The application encrypts, compresses and sends it to
 the other side over TCP or UDP. The application on the other side decompresses
-and decrypts the data received and writes the packet to the TAP device, 
+and decrypts the data received and writes the packet to the TAP device,
 the kernel handles the packet like it came from real physical device.
 
 4. What is the difference between TUN driver and TAP driver?
@@ -147,4 +147,4 @@ A TUN/TAP driver does provide a virtual network interface and it is possible
 to attach BPF to this interface.
 
 6. Does TAP driver support kernel Ethernet bridging?
-Yes. Linux and FreeBSD drivers support Ethernet bridging. 
+Yes. Linux and FreeBSD drivers support Ethernet bridging.
-- 
1.8.0.2

