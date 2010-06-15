Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab0FONGv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 09:06:51 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:36312 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755190Ab0FONGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 09:06:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=iRP4tYuVEV7mSWgsXdIp90UmVGIsiIQILfvnynIEl12te8gn2EVpSOh+t4do1cYk4n
         OMpltiy5J2MSV4RUUrAxeXEt5/pUvonODrEm2z0oEoRug1liT6xCn9xOCToW6ZRXo9xu
         3vnxCamcoGny8DlF/ZPP3ReUeNkC+kNKkfIXA=
From: Eric Lacombe <goretux@gmail.com>
To: skeggsb@gmail.com
Subject: Re: [Nouveau] [BUG ?] Nouveau driver on 330M GT
Date: Tue, 15 Jun 2010 15:06:26 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.32-22-generic; KDE/4.4.4; x86_64; ; )
Cc: Younes Manton <younes.m@gmail.com>, Dave Airlie <airlied@linux.ie>,
       nouveau@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <201006111052.29187.goretux@gmail.com> <201006151318.08619.goretux@gmail.com> <1276601463.2526.4.camel@nisroch>
In-Reply-To: <1276601463.2526.4.camel@nisroch>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201006151506.27154.goretux@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Is this a system with switchable graphics (Optimus probably)?  If so,
> fiddle with your BIOS options and try and enable only the NVIDIA board.

oops, my fault... I forgot to switch to the nvidia chip (my laptop is a sony 
vaio Z11Z9E) with the button. Here the new drm logs with a 2.6.35-rc2 kernel :

[   13.803030] [drm] Initialized drm 1.1.0 20060810
[   13.930690] [drm] MTRR allocation failed.  Graphics performance may suffer.
[   13.931448] [drm] set up 127M of stolen space
[   13.940481] [drm] nouveau 0000:01:00.0: Detected an NV50 generation card 
(0x0a5580a2)
[   13.946777] [drm] nouveau 0000:01:00.0: Attempting to load BIOS image from 
ACPI
[   14.242941] fb0: inteldrmfb frame buffer device
[   14.242944] drm: registered panic notifier
[   15.276155] [drm] nouveau 0000:01:00.0: ... appears to be valid
[   15.276159] [drm] nouveau 0000:01:00.0: BIT BIOS found
[   15.276163] [drm] nouveau 0000:01:00.0: Bios version 70.16.51.00
[   15.276165] [drm] nouveau 0000:01:00.0: Pointer to BIT loadval table 
invalid
[   15.276217] [drm] nouveau 0000:01:00.0: TMDS table revision 2.0 not 
currently supported
[   15.276219] [drm] nouveau 0000:01:00.0: Found Display Configuration Block 
version 4.0
[   15.276222] [drm] nouveau 0000:01:00.0: Raw DCB entry 0: 02000300 00000000
[   15.276225] [drm] nouveau 0000:01:00.0: Raw DCB entry 1: 048113b6 0f220014
[   15.276228] [drm] nouveau 0000:01:00.0: Raw DCB entry 2: 02002362 00020010
[   15.276230] [drm] nouveau 0000:01:00.0: Raw DCB entry 3: 08003382 00000010
[   15.276232] [drm] nouveau 0000:01:00.0: Raw DCB entry 4: 0000000e 00000000
[   15.276235] [drm] nouveau 0000:01:00.0: DCB connector table: VHER 0x40 5 16 
4
[   15.276238] [drm] nouveau 0000:01:00.0:   0: 0x00000000: type 0x00 idx 0 
tag 0xff
[   15.276241] [drm] nouveau 0000:01:00.0:   1: 0x00020147: type 0x47 idx 1 
tag 0x52
[   15.276244] [drm] nouveau 0000:01:00.0:   2: 0x00010261: type 0x61 idx 2 
tag 0x51
[   15.276246] [drm] nouveau 0000:01:00.0:   3: 0x01000331: type 0x31 idx 3 
tag 0xff
[   15.276249] [drm] nouveau 0000:01:00.0:   4: 0x00002430: type 0x30 idx 4 
tag 0x08
[   15.276268] [drm] nouveau 0000:01:00.0:   5: 0x00000560: type 0x60 idx 5 
tag 0xff
[   15.276290] [drm] nouveau 0000:01:00.0: Adaptor not initialised
[   15.276292] [drm] nouveau 0000:01:00.0: Running VBIOS init tables
[   15.276336] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 0 at offset 
0x6C90
[   15.279468] [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 
0
[   15.318263] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 1 at offset 
0x70F1
[   15.398432] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 2 at offset 
0x7FCA
[   15.398475] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 3 at offset 
0x7FEC
[   15.418961] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table 4 at offset 
0x814E
[   15.418966] [drm] nouveau 0000:01:00.0: Parsing VBIOS init table at offset 
0x81B3
[   15.448836] [drm] nouveau 0000:01:00.0: Couldn't find matching output script 
table
[   15.448841] [drm] nouveau 0000:01:00.0: 0x5CB9: parsing output script 0
[   15.448855] [drm] nouveau 0000:01:00.0: 0x58AE: parsing output script 0
[   15.448858] [drm] nouveau 0000:01:00.0: 0x58AE: parsing output script 0
[   15.448870] [drm] nouveau 0000:01:00.0: Detected 1024MiB VRAM
[   15.777179] [drm] nouveau 0000:01:00.0: 512 MiB GART (aperture)
[   15.777675] [drm] nouveau 0000:01:00.0: Allocating FIFO number 1
[   15.788999] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised 
FIFO 1
[   15.790494] [drm] nouveau 0000:01:00.0: Detected a DAC output
[   15.790496] [drm] nouveau 0000:01:00.0: Detected a DP output
[   15.790502] [drm] nouveau 0000:01:00.0: Detected a TMDS output
[   15.790503] [drm] nouveau 0000:01:00.0: Detected a TMDS output
[   15.790505] [drm] nouveau 0000:01:00.0: Detected a VGA connector
[   15.790603] [drm] nouveau 0000:01:00.0: Detected an eDP connector
[   15.790627] [drm] nouveau 0000:01:00.0: Detected a HDMI connector
[   15.790648] [drm] nouveau 0000:01:00.0: Detected a DVI-D connector
[   15.790669] [drm] nouveau 0000:01:00.0: Detected a DVI-I connector
[   15.790671] [drm] nouveau 0000:01:00.0:   no encoders, ignoring
[   15.790674] [drm] nouveau 0000:01:00.0: Detected a HDMI connector
[   15.790676] [drm] nouveau 0000:01:00.0:   no encoders, ignoring
[   15.853252] [drm] Cannot find any crtc or sizes - going 1024x768
[   15.853702] [drm] nouveau 0000:01:00.0: allocated 1024x768 fb: 0x40250000, 
bo ffff8801d523bc00
[   15.853757] [drm] Initialized nouveau 0.0.16 20090420 for 0000:01:00.0 on 
minor 1
[   30.785010] [drm] nouveau 0000:01:00.0: plugged Embedded DisplayPort-1


Hope this helps

	Eric


> 
> Dave has some patches that can retrieve the VBIOS image via ACPI which
> may be of use to you, but I'm not sure of the status.
> 
> Ben.
> 
> > Regards,
> > 
> > 	Eric
> > 
> > _______________________________________________
> > Nouveau mailing list
> > Nouveau@lists.freedesktop.org
> > http://lists.freedesktop.org/mailman/listinfo/nouveau
