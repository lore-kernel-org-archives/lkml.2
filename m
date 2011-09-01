Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481Ab1IANZG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 09:25:06 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:51157 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757313Ab1IANZC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 09:25:02 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: a3at.mail@gmail.com
In-Reply-To: <20110831112311.534d68d5@boulder.homenet>
References: <20110831112311.534d68d5@boulder.homenet>
Date: Thu, 1 Sep 2011 17:25:00 +0400
X-Google-Sender-Auth: shn5mEzo2VAFJqLBIog0xSqFDx8
Message-ID: <CAAW1UO-j6iP=soztf1O9u19Nu+xR6OGJmmYcBdGbX08=J9caUQ@mail.gmail.com>
Subject: Re: nouveau regression in 3.1-rc4
From: Azat Khuzhin <dohardgopro@gmail.com>
To: Chris Vine <chris@cvine.freeserve.co.uk>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I have some problems with nouveau driver too

I have GeForce2 MX/MX 100/200, and a big screen 23", and set up
resolution to 1920x1080
With driver for windows it works, but with driver for linux (from
nvidia.org) doesn't, and it write some errors to logs, but I don`t
have access to that computer now
And I'd try nouveau, and it not works too, but after I set up
resolution from 1920x1080 to 1024x768 it works

The question is, is there any way to make nouveau works with by
monitor, video card and resolution 1920x1080?

On Wed, Aug 31, 2011 at 2:23 PM, Chris Vine <chris@cvine.freeserve.co.uk> wrote:
> The nouveau graphics driver has a regression in 3.1-rc4 on my ancient
> nvidia GeForce2 MX/MX 400 card.  It works OK in kernel 3.0.4 (I have
> not tested with earlier versions of 3.1-rc).
>
> The following is logged to syslog:
>
> grep nouveau /var/log/syslog
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: TV-1 has no encoders, removing
> Aug 31 11:06:35 boulder kernel: IP: [<e0ba3f17>] nouveau_bo_vma_add+0xd/0xa8 [nouveau]
> Aug 31 11:06:35 boulder kernel: Modules linked in: nouveau(+) snd_emu10k1 snd_rawmidi fbcon snd_ac97_codec ac97_bus tileblit snd_pcm font bitblit ttm snd_seq_device softcursor snd_timer drm_kms_helper uhci_hcd snd_page_alloc snd_util_mem drm snd_hwdep snd ehci_hcd soundcore i2c_algo_bit parport_pc processor thermal_sys parport hwmon 8139too mii i2c_core mxm_wmi wmi button sr_mod sg cdrom intel_agp intel_gtt evdev agpgart
> Aug 31 11:06:35 boulder kernel: EIP is at nouveau_bo_vma_add+0xd/0xa8 [nouveau]
> Aug 31 11:06:35 boulder kernel:  [<e0ba4bae>] ? nouveau_fence_channel_init+0x4b/0x1da [nouveau]
> Aug 31 11:06:35 boulder kernel:  [<e0ba2447>] ? nouveau_dma_init+0x247/0x280 [nouveau]
> Aug 31 11:06:35 boulder kernel:  [<e0b9db06>] ? nouveau_channel_alloc+0x355/0x5a2 [nouveau]
> Aug 31 11:06:35 boulder kernel:  [<e0b9c759>] ? nouveau_card_init+0xf34/0x1085 [nouveau]
> Aug 31 11:06:35 boulder kernel:  [<e0b9ccc6>] ? nouveau_load+0x355/0x60c [nouveau]
> Aug 31 11:06:35 boulder kernel: EIP: [<e0ba3f17>] nouveau_bo_vma_add+0xd/0xa8 [nouveau] SS:ESP 0068:df7a7cc8
>
> The following is logged to messages:
>
> grep nouveau /var/log/messages
> Aug 31 11:06:35 boulder kernel: nouveau 0000:01:00.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Detected an NV10 generation card (0x011000b2)
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from PRAMIN
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: ... appears to be valid
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: BMP BIOS found
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: BMP version 5.20
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Bios version 03.11.01.30
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Found Display Configuration Block version 1.5
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Raw DCB entry 0: f0003f00 000088b8
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Raw DCB entry 1: f2204001 ffffffff
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Raw DCB entry 2: f2244001 ffffffff
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 0xAB70
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 0xB25E
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 0xAB8B
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 0xB205
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 0xAC1E
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 5 at offset 0xAD72
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 6 at offset 0xAC43
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 7 at offset 0xAD0D
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: 0 available performance level(s)
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: c: memory 334MHz core 174MHz
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Detected 64MiB VRAM
> Aug 31 11:06:35 boulder kernel: nouveau 0000:01:00.0: putting AGP V2 device into 4x mode
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: 128 MiB GART (aperture)
> Aug 31 11:06:35 boulder kernel: [drm] nouveau 0000:01:00.0: Saving VGA fonts
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
