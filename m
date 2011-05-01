Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754275Ab1EAAij (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Apr 2011 20:38:39 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:36062 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752002Ab1EAAii (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Apr 2011 20:38:38 -0400
X-Authenticated: #9642893
X-Provags-ID: V01U2FsdGVkX19CmrVhJoVCbjC7T/8q4rkQ9MQwd3CItPlZ0cRq10
	6enqrHm37xkakV
Content-Type: text/plain; charset=iso-8859-15; format=flowed; delsp=yes
Date: Sun, 01 May 2011 02:38:32 +0200
To: linux-kernel@vger.kernel.org
Subject: Bug Report: 2.6.38 causes loop / lockup at boot
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
From: Markus <progrox@gmx.net>
Message-ID: <op.vur1eiisl0p1sd@altair.fritz.box>
User-Agent: Opera Mail/11.10 (Win32)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Summary: A vanilla net-install of Arch Linux or Debian Testing will result in an unbootable system

Keywords: Kernel, Boot, Lockup, Loop, ACPI

Kernel Version: 2.6.38.2 to .4

Environment: An old laptop (Gericom Overdose T2, around 2001) with a SiS 630 board, Pentium 3 1.26GHz, ACPI 1.0B compliant

Description:

After a fresh net-install of Arch Linux (i686), when the system is booted from harddisk for the first time, it will loop these messages over and over, effectively making the system unusable. The messages never make it into a log (and because they run by very fast, this is all I could glean). Happens with both kernels 2.6.38.2 and 2.6.38.3:

[<c11ec???>] ? acpi_add_single_object
[<c11ec???>] ? acpi_device_suspend

For 2.6.38.4, the messages change slightly:

[<c11ec???>] ? acpi_add_single_object
[<c11ed???>] ? unregister_acpi_bus_type

Something similar happens after installing Debian Stable (i386 LXDE) and updating to Testing, except that the messages don't loop, but there's only about 10 of them before the system freezes up completely.

Fedora 15 beta with 2.6.38 booted fine.


------------------------------------


Hope this is the right address. Feel free to contact me, but I'm a relative noob.
