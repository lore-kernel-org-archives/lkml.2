Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753645Ab1LAMaY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 07:30:24 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:33330 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752300Ab1LAMaX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 07:30:23 -0500
Message-ID: <4ED7735A.1020903@suse.cz>
Date: Thu, 01 Dec 2011 13:30:18 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111123 Thunderbird/9.0
MIME-Version: 1.0
To: Keith Packard <keithp@keithp.com>
CC: dri-devel@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: g33: GPU hangs
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

both yesterday and today, my GPU hung. Both happened when I opened
google front page in firefox.

I'm running 3.2.0-rc3-next-20111130. Given it happened twice in the past
24 hours, it looks like a regression from next-20111124. Or is this a
userspace issue (I might updated some packages)?

i915_error_state dumps from the two hangs are here:
http://www.fi.muni.cz/~xslaby/sklad/panics/915_error_state_0
http://www.fi.muni.cz/~xslaby/sklad/panics/915_error_state_second

# rpm -q Mesa libdrm xorg-x11-server
Mesa-7.11.1-5.1.x86_64
libdrm-2.4.27-2.1.x86_64
xorg-x11-server-7.6_1.10.4-39.1.x86_64

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

regards,
-- 
js
suse labs
