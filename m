Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755213Ab2HJQqH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 12:46:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:32978 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986Ab2HJQqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 12:46:03 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <linux-kernel@vger.kernel.org>
Cc: <ap@solarrain.com>
Subject: Upgraded from 3.4 to 3.5.1 kernel: machine does not boot
Date: Fri, 10 Aug 2012 12:45:59 -0400
Message-ID: <0bac01cd7717$9fa6bbf0$def433d0$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac13FuVWg5MMg3U1RMS3xOtB0thpsA==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Motherboard: Supermicro X8DTH-6F
Distro: Debian Testing x86_64

>From 3.4 -> 3.5.1 on x86_64 make oldconfig and a few minor changes and the
machine attempts to boot but hangs at the filesystem mounting part of the
boot process.

Picture of where it stops working (a little burry but readable)
http://home.comcast.net/~jpiszcz/20120810/3.5-kernel-hangs.jpg

Kernel config 3.4 (working)
http://home.comcast.net/~jpiszcz/20120810/config-3.4.txt

Kernel config 3.5.1 (hangs)
http://home.comcast.net/~jpiszcz/20120810/config-3.5.1.txt

As you see towards the end the machine has been sitting there for 1 hour as
that's the timeout I have the drives spindown on the 3ware card.

Any thoughts as what is wrong here?

Diff between the two:

$ diff -u config-3.4.txt  config-3.5.1.txt  |grep '^+C'
+CONFIG_ARCH_SUPPORTS_UPROBES=y
+CONFIG_BUILDTIME_EXTABLE_SORT=y
+CONFIG_CLOCKSOURCE_WATCHDOG=y
+CONFIG_ARCH_CLOCKSOURCE_DATA=y
+CONFIG_GENERIC_TIME_VSYSCALL=y
+CONFIG_GENERIC_CLOCKEVENTS=y
+CONFIG_GENERIC_CLOCKEVENTS_BUILD=y
+CONFIG_GENERIC_CLOCKEVENTS_BROADCAST=y
+CONFIG_GENERIC_CLOCKEVENTS_MIN_ADJUST=y
+CONFIG_GENERIC_CMOS_UPDATE=y
+CONFIG_TICK_ONESHOT=y
+CONFIG_NO_HZ=y
+CONFIG_HIGH_RES_TIMERS=y
+CONFIG_RCU_FANOUT_LEAF=16
+CONFIG_GENERIC_SMP_IDLE_THREAD=y
+CONFIG_HAVE_ARCH_SECCOMP_FILTER=y
+CONFIG_SECCOMP_FILTER=y
+CONFIG_CROSS_MEMORY_ATTACH=y
+CONFIG_X86_DEV_DMA_OPS=y
+CONFIG_NETFILTER_NETLINK=y
+CONFIG_NF_CT_NETLINK=y
+CONFIG_HAVE_BPF_JIT=y
+CONFIG_E1000E=y
+CONFIG_IXGBE_HWMON=y
+CONFIG_NET_VENDOR_I825XX=y
+CONFIG_HID=y
+CONFIG_HIDRAW=y
+CONFIG_HID_GENERIC=y
+CONFIG_USB_HID=y
+CONFIG_HID_PID=y
+CONFIG_USB_HIDDEV=y
+CONFIG_NEW_LEDS=y
+CONFIG_LEDS_CLASS=y
+CONFIG_NFS_V2=y
+CONFIG_PANIC_ON_OOPS_VALUE=0
+CONFIG_RCU_CPU_STALL_INFO=y
+CONFIG_CRYPTO_CRC32C=y
+CONFIG_GENERIC_STRNCPY_FROM_USER=y
+CONFIG_GENERIC_STRNLEN_USER=y

Justin.


