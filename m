Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348Ab0ELNxh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 09:53:37 -0400
Received: from fg-out-1718.google.com ([72.14.220.154]:58554 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752089Ab0ELNxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 09:53:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=kV9LiDgSfe7mkrmU5qkjQ1c4mFJ6569dvrfD+Y68CEYPeIWVTbcCUxsoeSKfatQtV3
         XdDBYyW2fYwKX7HYVSHeH05KLHdTaI1wiwklTLTnnDD4Oh2NTOJ2hEtyZ1N0uJ+c8Pty
         osOPn7Crz6Efi5SMS8uDCeamGzDHqgIcQCM8g=
Subject: [pm] resume from s3 oops? (last checked on rc6)
From: "=?gb2312?Q?=B1=F6=CE=F7=C3=C9?=" <binximeng@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: BinXimeng@gmail.com
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 May 2010 15:59:32 +0200
Message-ID: <1273672772.7284.32.camel@eee51>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi lkml,

I'm trying to get suspend to ram working on a opensuse 11.2. (The box is
unfortunately not connected to the Internet). So far I've tried with
distribution's kernel 2.6.31.12 & now with 2.6.34-rc6 (already
downloaded a copy of rc7 and will try it today)

It suspends fine with "echo mem > /sys/power/state", resumes not though.
The caps lock and scroll lock leds are flashing, I think this relates to
a kernel oops? However, screen remains black.

I did this from a "bare" system with vga=0 init=/bin/zsh command line.
When using acpi_sleep=s3_beep, I get 3 high + 1 low beep right after
wake-up. With acpi_sleep=s3_mode, I don't get the blinking keyboard
leds, but the resume doesn't work either, especially do I believe it is
not only a "black screen", otherwise I should be able to toggle the
keyboard leds after resume.

The board has a debug led connected to an AMI bios, which shows "24" --
manual claims this to mean "Uncompress and initialize any platform
specific BIOS modules. GPNV is initialized at this checkpoint." Don't
know if this has any meaning and not just bogus though.

probably unrelated, s1&s4 work.

The hardware in question: ASRock Intel-X58 Extreme3 motherboard, AMD
HD3450 graphics.

any debug help/suggestions, things to try/look at to track this down
that you guys could give me?

cheers, ximeng

