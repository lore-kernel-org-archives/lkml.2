Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab2JUJ0R (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 05:26:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:49833 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088Ab2JUJ0Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 05:26:16 -0400
Date: Sun, 21 Oct 2012 11:26:09 +0200
From: Heinz Diehl <htd@fritha.org>
To: =?utf-8?B?UGF3ZcWC?= Sikora <pawel.sikora@agmk.net>
Cc: Marcin Slusarz <marcin.slusarz@gmail.com>,
        Martin Peres <martin.peres@labri.fr>,
        Heinz Diehl <htd@fancy-poultry.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        marcheu@chromium.org
Subject: Re: Linux 3.7-rc1 (nouveau_bios_score oops).
Message-ID: <20121021092609.GA1563@fritha.org>
References: <1724445.dN2yMEzN6d@localhost>
 <20121020212036.GA1698@fritha.org>
 <20121020221948.GE5826@joi.lan>
 <2155889.FOmdXlva7q@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <2155889.FOmdXlva7q@localhost>
Organization: private site
OpenPGP: id=BBAD7AE7; url=http://www.fritha.org/htd.asc
User-Agent: Mutt/1.5.21+66 (70810a88ce9f) (2011-07-01)
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V02:K0:3gQmhJMyRUTfBySQ+osHKT2cLWf8CdIt8Dyu0Sz2bJP
 VnnZdR24pxqaYFNpYCWCecZVJaMXGiYnGTTNH6BfDR0+iaXBqh
 XCYU6WTfzhMyQWQc/xFDa7BpRwpu0W4GGYRBwFARYL938rF/ua
 I1fln3pxw8p5K7jxAya1zj8ZAnyPz7ABtqh8MU2BIIXd5tkRSI
 LjvpN5KvE6JobdZgZ/A8h964soyR/jf4wMcJVLLCU1LxEio9lt
 isBwm8PLyuFkDC9CGd7brLh+eiw3ebE9KYsf9sZZ3T5ckr4SIj
 +YpYeCtaSc52IxC2HeADQMoQagkNqY84xfTaSx57QEi7ts8b8/
 PxkBp+TosA9Ds/xElSfU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.10.2012, Paweł Sikora wrote: 

> with these both patches applied my laptop boots and gui works fine.

The same here. The two patches together, applied to 3.7-rc1 let my
machine boot again. Here's the relevant dmesg cut:

[    3.702671] nouveau  [  DEVICE][0000:01:00.0] BOOT0  : 0x0a8800b1
[    3.704643] nouveau  [  DEVICE][0000:01:00.0] Chipset: GT218 (NVA8)
[    3.707003] nouveau  [  DEVICE][0000:01:00.0] Family : NV50
[    3.711393] nouveau  [   VBIOS][0000:01:00.0] checking PRAMIN for image...
[    3.712793] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
[    3.714147] nouveau  [   VBIOS][0000:01:00.0] checking PROM for image...
[    3.715578] nouveau  [   VBIOS][0000:01:00.0] ... signature not found
[    3.716969] nouveau  [   VBIOS][0000:01:00.0] checking ACPI for image...
[    4.207512] nouveau  [   VBIOS][0000:01:00.0] ... appears to be valid
[    4.209711] nouveau  [   VBIOS][0000:01:00.0] using image from ACPI
[    4.212469] nouveau  [   VBIOS][0000:01:00.0] BIT signature found
[    4.214855] nouveau  [   VBIOS][0000:01:00.0] version 70.18.5d.00
[    4.217554] nouveau  [ DEVINIT][0000:01:00.0] adaptor not initialised
[    4.219922] nouveau  [   VBIOS][0000:01:00.0] running init tables
[    4.342202] nouveau  [     MXM][0000:01:00.0] no VBIOS data, nothing to do
[    4.343590] nouveau  [     PFB][0000:01:00.0] RAM type: DDR3
[    4.344916] nouveau  [     PFB][0000:01:00.0] RAM size: 1024 MiB
[    4.991887] vga_switcheroo: enabled
[    4.993495] [TTM] Zone  kernel: Available graphics memory: 1917720 kiB
[    4.994911] [TTM] Initializing pool allocator
[    4.996228] [TTM] Initializing DMA pool allocator
[    4.998915] nouveau  [     DRM] VRAM: 1024 MiB
[    5.000251] nouveau  [     DRM] GART: 512 MiB
[    5.001579] nouveau  [     DRM] BIT BIOS found
[    5.002904] nouveau  [     DRM] Bios version 70.18.5d.00
[    5.004229] nouveau  [     DRM] TMDS table version 2.0
[    5.005545] nouveau  [     DRM] DCB version 4.0
[    5.006810] nouveau  [     DRM] DCB outp 00: 02014300 00000000
[    5.008115] nouveau  [     DRM] DCB conn 00: 00000040
[    5.009441] nouveau  [     DRM] DCB conn 01: 00410146
[    5.010745] nouveau  [     DRM] DCB conn 02: 00001261
[    5.012019] nouveau  [     DRM] DCB conn 03: 00002330
[    5.013255] nouveau  [     DRM] DCB conn 04: 00000400
[    5.014452] nouveau  [     DRM] DCB conn 05: 00000560
[    5.052344] [drm] Supports vblank timestamp caching Rev 1 (10.10.2010).
[    5.053486] [drm] No driver support for vblank timestamp query.
[    5.054590] nouveau  [     DRM] ACPI backlight interface available,not registering our own
[    5.356822] nouveau  [     DRM] 3 available performance level(s)
[    5.358682] nouveau  [     DRM] 0: core 135MHz shader 270MHz memory 135MHz voltage 850mV
[    5.360442] nouveau  [     DRM] 1: core 405MHz shader 810MHz memory 405MHz voltage 850mV
[    5.362215] nouveau  [     DRM] 3: core 606MHz shader 1468MHz memory 667MHz voltage 1000mV
[    5.363998] nouveau  [     DRM] c: core 405MHz shader 810MHz memory 405MHz
[    5.404143] nouveau  [     DRM] MM: using COPY for buffer copies
[    5.481593] No connectors reported connected with modes
[    5.482667] [drm] Cannot find any crtc or sizes - going 1024x768
[    5.517932] nouveau  [     DRM] allocated 1024x768 fb: 0x70000, bo ffff88013a6d3400
[    5.519236] fb1: nouveaufb frame buffer device
[    5.520368] [drm] Initialized nouveau 1.1.0 20120801 for 0000:01:00.0 on minor 1
[    5.527378] dracut: Starting plymouth daemon

