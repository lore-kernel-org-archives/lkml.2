Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab2EXDdb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 23:33:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65069 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932116Ab2EXDda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 23:33:30 -0400
Date: Thu, 24 May 2012 11:33:58 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Richard Zhao <richard.zhao@freescale.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        vinod.koul@intel.com, dan.j.williams@intel.com, linuxzsc@gmail.com,
        shawn.guo@gmail.com, kernel@pengutronix.de
Subject: Re: [PATCH 1/1] dma: imx-sdma: buf_tail should be initialize in
 prepare function
Message-ID: <20120524033356.GC17621@S2101-09.ap.freescale.net>
References: <1337603494-27464-1-git-send-email-richard.zhao@freescale.com>
 <20120524032026.GB17621@S2101-09.ap.freescale.net>
 <20120524032659.GA19682@b20223-02.ap.freescale.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120524032659.GA19682@b20223-02.ap.freescale.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 11:27:00AM +0800, Richard Zhao wrote:
> > root@linaro-developer:~# aplay audio8k16S.wav
> > Playing WAVE 'audio8k16S.wav' : Signed 16 bit Little Endian, Rate 8000 Hz, Stere
> > o
> > ^Z
> > [1]+  Stopped                 aplay audio8k16S.wav
> > root@linaro-developer:~# fg
> > aplay audio8k16S.wav
> > underrun!!! (at least 2034.382 ms long)
> Does the audio playback recover? Without the patch, sometimes the
> playback will have distortion and play too fast.
> 
No, it does not recover.

-- 
Regards,
Shawn
