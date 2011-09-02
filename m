Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751161Ab1IBLmw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 07:42:52 -0400
Received: from ch-smtp05.sth.basefarm.net ([80.76.153.6]:38722 "EHLO
	ch-smtp05.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750702Ab1IBLmv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 07:42:51 -0400
X-Mailer: exmh version 2.7.2 04/02/2003 (gentoo 2.7.2) with nmh-1.3-dev
To: linux-kernel@vger.kernel.org, linux-sound@vger.kernel.org
Subject: Aureal issues on resume
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Fri, 02 Sep 2011 13:41:42 +0200
From: Anders Eriksson <aeriksson@fastmail.fm>
Message-Id: <20110902114143.821893BC17F@tippex.mynet.homeunix.org>
X-Originating-IP: 83.252.228.248
X-Scan-Result: No virus found in message 1QzS8x-0003oe-Hs.
X-Scan-Signature: ch-smtp05.sth.basefarm.net 1QzS8x-0003oe-Hs 9e1b234d5e1fde09c55c49fbdb8f1a8b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Hi, upon resuming from hibernation, I see this in my log:

Sep  2 11:15:20 tippex kernel: [72436.287020] vortex_adb_addroutes: unending route! 0x10
Sep  2 11:15:20 tippex kernel: [72436.287127] vortex_adb_addroutes: unending route! 0x838
Sep  2 11:15:20 tippex kernel: [72436.287277] vortex_adb_addroutes: unending route! 0x11
Sep  2 11:15:20 tippex kernel: [72436.287418] vortex_adb_addroutes: unending route! 0x8b9
Sep  2 11:15:20 tippex kernel: [72436.292037] Vortex: vortex_fifo_setadbctrl fail
Sep  2 11:15:55 tippex kernel: [72471.403490] vortex_adb_delroutes: route not found! 0x10
Sep  2 11:15:55 tippex kernel: [72471.403596] vortex_adb_delroutes: route not found! 0x838
Sep  2 11:15:55 tippex kernel: [72471.403710] vortex_adb_delroutes: route not found! 0x11
Sep  2 11:15:55 tippex kernel: [72471.403811] vortex_adb_delroutes: route not found! 0x8b9

And the sound is no more. I need to reboot to get it back.

If memory serves, it's been there since 2.6.30 or so. Any ideas what can be 
triggering it?

lspci says it's an 
00:04.0 Multimedia audio controller: Aureal Semiconductor Vortex 1 (rev 02)
        Subsystem: Diamond Multimedia Systems Sonic Impact A3D
        Flags: bus master, medium devsel, latency 64, IRQ 11
        Memory at 50000000 (32-bit, non-prefetchable) [size=128K]
        I/O ports at 10b0 [size=8]
        I/O ports at 10b8 [size=8]
        Capabilities: [dc] Power Management version 1
        Kernel driver in use: snd_au8820
        Kernel modules: snd-au8820



-Anders

