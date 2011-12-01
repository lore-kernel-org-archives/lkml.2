Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab1LAOht (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 09:37:49 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:56157 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754706Ab1LAOhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 09:37:48 -0500
Message-ID: <4ED79138.5060703@suse.cz>
Date: Thu, 01 Dec 2011 15:37:44 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111123 Thunderbird/9.0
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: g33: tiled output
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

For some time, I'm seeing a tiled output like:
http://www.fi.muni.cz/~xslaby/sklad/panics/bad_tile.png

This happens sometimes when I open selected pages in firefox. Like
maps above.

Currently I'm running 3.2.0-rc3-next-20111130. This started appearing
after I switched to desktop fx. Will anything from the debugfs help to
track this down? Or better to report this to freedesktop.org?

# rpm -q Mesa libdrm xorg-x11-server
Mesa-7.11.1-5.1.x86_64
libdrm-2.4.27-2.1.x86_64
xorg-x11-server-7.6_1.10.4-39.1.x86_64

intel_drv version 2.16.0

00:02.0 VGA compatible controller [0300]: Intel Corporation 82G33/G31
Express Integrated Graphics Controller [8086:29c2] (rev 02) (prog-if 00
[VGA controller])
        Subsystem: Intel Corporation 82G33/G31 Express Integrated
Graphics Controller [8086:29c2]
        Flags: bus master, fast devsel, latency 0, IRQ 42
        Memory at feb80000 (32-bit, non-prefetchable) [size=512K]
        I/O ports at ec00 [size=8]
        Memory at d0000000 (32-bit, prefetchable) [size=256M]
        Memory at fea00000 (32-bit, non-prefetchable) [size=1M]
        Expansion ROM at <unassigned> [disabled]
        Capabilities: [90] MSI: Enable+ Count=1/1 Maskable- 64bit-
        Capabilities: [d0] Power Management version 2
        Kernel driver in use: i915
thanks,
-- 
js
suse labs
