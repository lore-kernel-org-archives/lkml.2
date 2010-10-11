Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab0JKH6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 03:58:49 -0400
Received: from vs244178.vserver.de ([62.75.244.178]:59121 "EHLO
	smtp.eikelenboom.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab0JKH6s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 03:58:48 -0400
Date: Mon, 11 Oct 2010 09:58:44 +0200
From: Sander Eikelenboom <linux@eikelenboom.it>
Organization: Eikelenboom IT services
X-Priority: 3 (Normal)
Message-ID: <1967177642.20101011095844@eikelenboom.it>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
Subject: Re: [Bug #16614] [2.6.35] usb 2.0 em28xx  kernel panic general protection fault: 0000 [#1] SMP          RIP: 0010:[<ffffffffa004fbc5>]  [<ffffffffa004fbc5>] em28xx_isoc_copy_vbi+0x62e/0x812 [em28xx]
In-Reply-To: <yeAD7A8RDxC.A.zI.fwgsMB@chimera>
References: <pyPtebg28EI.A.ZPH.NvgsMB@chimera> <yeAD7A8RDxC.A.zI.fwgsMB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Rafael,

This one seems to be fixed, in the sense that i still get an error, but it doesn't crash the kernel.
And since it was my mistake to use the deprecated video4linux interface instead of the video4linux2, i think it's fine to consider it fixed.


security:~# ffmpeg -f video4linux -r 25 -s 720x576 -i /dev/video0 out.flv
FFmpeg version SVN-r20654, Copyright (c) 2000-2009 Fabrice Bellard, et al.
  built on Nov 29 2009 08:11:53 with gcc 4.3.4
  configuration: --prefix=/usr --extra-cflags='-Wall -g ' --cc='ccache cc' --enable-shared --enable-libmp3lame --enable-gpl --enable-libfaad --enable-libvorbis --enable-pthreads --enable-libfaac --enable-libxvid --enable-postproc --enable-x11grab --enable-libgsm --enable-libopencore-amrnb --enable-libopencore-amrwb --enable-libx264 --enable-libtheora --enable-libdc1394 --enable-libspeex --enable-nonfree --disable-stripping --enable-avfilter --enable-libdirac --disable-decoder=libdirac --enable-libschroedinger --disable-encoder=libschroedinger --enable-avfilter-lavf --enable-libopenjpeg --enable-version3 --disable-altivec --disable-armv5te --disable-armv6 --disable-vis
  libavutil     50. 5. 1 / 50. 5. 1
  libavcodec    52.42. 0 / 52.42. 0
  libavformat   52.39. 2 / 52.39. 2
  libavdevice   52. 2. 0 / 52. 2. 0
  libavfilter    1.11. 0 /  1.11. 0
  libswscale     0. 7. 2 /  0. 7. 2
  libpostproc   51. 2. 0 / 51. 2. 0
[video4linux @ 0xff45e0]VIDIOCMCAPTURE: Cannot allocate memory
/dev/video0: I/O error occurred
Usually that means that input file is truncated and/or corrupted.


--

Sander


Sunday, October 10, 2010, 9:18:51 PM, you wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.34 and 2.6.35.

> The following bug entry is on the current list of known regressions
> introduced between 2.6.34 and 2.6.35.  Please verify if it still should
> be listed and let the tracking team know (either way).


> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16614
> Subject         : [2.6.35] usb 2.0 em28xx  kernel panic general protection fault: 0000 [#1] SMP          RIP: 0010:[<ffffffffa004fbc5>]  [<ffffffffa004fbc5>] em28xx_isoc_copy_vbi+0x62e/0x812 [em28xx]
> Submitter       : Sander Eikelenboom <linux@eikelenboom.it>
> Date            : 2010-08-10 22:12 (62 days old)
> Message-ID      : <61936849.20100811001257@eikelenboom.it>
> References      : http://marc.info/?l=linux-kernel&m=128152075830927&w=2





-- 
Best regards,
 Sander                            mailto:linux@eikelenboom.it

