Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161134Ab2KWKVw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 05:21:52 -0500
Received: from mail.karo-electronics.de ([81.173.242.67]:51768 "EHLO
	mail.karo-electronics.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161082Ab2KWKVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 05:21:51 -0500
Message-ID: <20655.20022.819710.39381@ipc1.ka-ro>
Date: Fri, 23 Nov 2012 11:21:42 +0100
From: =?utf-8?Q?Lothar_Wa=C3=9Fmann?= <LW@KARO-electronics.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: alsa-devel@alsa-project.org, Shawn Guo <shawn.guo@linaro.org>,
        linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] ASoC: fsl: fix miscompilation of snd-soc-imx-pcm
In-Reply-To: <20121123100849.GC4529@opensource.wolfsonmicro.com>
References: <20121123081307.GA4529@opensource.wolfsonmicro.com>
	<1353661933-27659-1-git-send-email-LW@KARO-electronics.de>
	<20121123100849.GC4529@opensource.wolfsonmicro.com>
X-Mailer: VM 8.1.0 under 23.2.1 (x86_64-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Mark Brown writes:
> On Fri, Nov 23, 2012 at 10:12:13AM +0100, Lothar Waßmann wrote:
> > Due to a broken make rule, sound/soc/fsl/imx-pcm-dma.c or
> > sound/soc/fsl/imx-pcm-fiq.c (whatever is selected via Kconfig) will
> > not be compiled into imx-pcm.o when building as module, i.e.:
> 
> What I've been trying to do is get you to tell me what the problem is
> with the Makefile rule, it's really not clear to me what the issue is or
> why your change is better.  I can see the practical results but nothing
> about how they came to be which makes it very hard to tell if this is a
> good fix.
> 
I already included the actual error messages I got when loading the
sound module.
I also mentioned, that in case of module build some source files
aren't being compiled with those rules. What else do you expect?


Lothar Waßmann
-- 
___________________________________________________________

Ka-Ro electronics GmbH | Pascalstraße 22 | D - 52076 Aachen
Phone: +49 2408 1402-0 | Fax: +49 2408 1402-10
Geschäftsführer: Matthias Kaussen
Handelsregistereintrag: Amtsgericht Aachen, HRB 4996

www.karo-electronics.de | info@karo-electronics.de
___________________________________________________________
