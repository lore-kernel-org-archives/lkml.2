Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab0HTLJ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 07:09:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46514 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752718Ab0HTLJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 07:09:55 -0400
Date: Fri, 20 Aug 2010 12:09:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Nicolas Pitre <nico@cam.org>
Subject: Re: [PATCH] ASoC: multi-component: remove include of pxa2xx-pcm.h
 in pxa2xx-ac97.c
Message-ID: <20100820110953.GG13668@rakim.wolfsonmicro.main>
References: <1282281816.7214.4.camel@mola>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1282281816.7214.4.camel@mola>
X-Cookie: No guts, no glory.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 01:23:36PM +0800, Axel Lin wrote:
> Fix reference to moved header file, which was unused anyway.
> This change fixes below build error:
>   CC      sound/soc/pxa/pxa2xx-ac97.o
> sound/soc/pxa/pxa2xx-ac97.c:27:24: error: pxa2xx-pcm.h: No such file or directory
> make[3]: *** [sound/soc/pxa/pxa2xx-ac97.o] Error 1
> make[2]: *** [sound/soc/pxa] Error 2
> make[1]: *** [sound/soc] Error 2
> make: *** [sound] Error 2

Applied, thanks.
