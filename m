Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755327Ab0JOKI7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 06:08:59 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47057 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab0JOKI6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 06:08:58 -0400
Subject: Re: [PATCH] sound/soc/codecs/wm8994.c: Remove unused vol
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Joe Perches <joe@perches.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Peter Hsiang <Peter.Hsiang@maxim-ic.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Peter Ujfalusi <peter.ujfalusi@nokia.com>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jesse Marroquin <Jesse.Marroquin@maxim-ic.com>
In-Reply-To: <1286983191.1117.338.camel@Joe-Laptop>
References: <B2150E1E4418E1438554A300EA5040E40D469C124D@ITSVLEX06.it.maxim-ic.internal>
	 <B2150E1E4418E1438554A300EA5040E40D469C124F@ITSVLEX06.it.maxim-ic.internal>
	 <1286934472.1117.129.camel@Joe-Laptop>
	 <20101013082414.GD6424@rakim.wolfsonmicro.main>
	 <1286971846.1117.191.camel@Joe-Laptop>
	 <20101013123301.GL6424@rakim.wolfsonmicro.main>
	 <1286983191.1117.338.camel@Joe-Laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 15 Oct 2010 11:08:53 +0100
Message-ID: <1287137333.3271.8.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-10-13 at 08:19 -0700, Joe Perches wrote:
> Remove unused vol from struct access_mask
> 
> Reduces object size ~3kb.
> 
> $ size sound/soc/codecs/wm8994.o*
>    text	   data	    bss	    dec	    hex	filename
>   40727	   4384	   4480	  49591	   c1b7	sound/soc/codecs/wm8994.o.new
>   43879	   4384	   4480	  52743	   ce07	sound/soc/codecs/wm8994.o.old
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

