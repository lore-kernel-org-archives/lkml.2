Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756746Ab2GQVOR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 17:14:17 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45745 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755209Ab2GQVOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 17:14:16 -0400
Date: Wed, 18 Jul 2012 00:14:11 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: 3.5-rc7: nouveau doesn't X on NVC0
Message-ID: <20120717211411.GA2800@p183.telecom.by>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FB console is OK, when switching to VT7, there is no KDM prompt.
Instead looping messages appear:

	Failed to idle channel 1
	0x2634 != chid: 0x00100001
	PFIFO: unknown status 0x00000100
	PFIFO - playlist update failed
	Failed to idle channel 2
		...
	Failed to idle channel 1
		...

http://img-fotki.yandex.ru/get/6400/31867379.3/0_a444b_12b9cdae_XL.jpg

Screen eventually blanks and can be restored back by pressing a key or
moving mouse.

dmesg from working kernel (3.4.4)

[drm] nouveau 0000:01:00.0: Detected an NVc0 generation card (0x0c8300a1)
[drm] nouveau 0000:01:00.0: Checking PRAMIN for VBIOS
[drm] nouveau 0000:01:00.0: ... appears to be valid
[drm] nouveau 0000:01:00.0: Using VBIOS from PRAMIN
[drm] nouveau 0000:01:00.0: BIT BIOS found
[drm] nouveau 0000:01:00.0: Bios version 70.10.27.00
[drm] nouveau 0000:01:00.0: TMDS table version 2.0
[drm] nouveau 0000:01:00.0: MXM: no VBIOS data, nothing to do
[drm] nouveau 0000:01:00.0: DCB version 4.0
[drm] nouveau 0000:01:00.0: DCB outp 00: 02000300 00000000
[drm] nouveau 0000:01:00.0: DCB outp 01: 01000302 00020030
[drm] nouveau 0000:01:00.0: DCB outp 02: 04011380 00000000
[drm] nouveau 0000:01:00.0: DCB outp 03: 08011382 00020030
[drm] nouveau 0000:01:00.0: DCB outp 04: 02022362 00020010
[drm] nouveau 0000:01:00.0: DCB conn 00: 00001030
[drm] nouveau 0000:01:00.0: DCB conn 01: 00010130
[drm] nouveau 0000:01:00.0: DCB conn 02: 00002261
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0x6A28
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0x70DA
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0x85AA
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0x85B4
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0x8828
[drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 0x888D
[drm] nouveau 0000:01:00.0: 0x888D: Condition still not met after 20ms, skipping following opcodes
[drm] nouveau 0000:01:00.0: Detected 1280MiB VRAM (GDDR5)
[drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[drm] nouveau 0000:01:00.0: 0 available performance level(s)
[drm] nouveau 0000:01:00.0: c: core 50MHz shader 101MHz memory 135MHz voltage 913mV fanspeed 41%
[drm] nouveau 0000:01:00.0: allocated 1280x1024 fb: 0x1e0000, bo ffff880235a03360
fbcon: nouveaufb (fb0) is primary device
fb0: nouveaufb frame buffer device
[drm] Initialized nouveau 1.0.0 20120316 for 0000:01:00.0 on minor 0
