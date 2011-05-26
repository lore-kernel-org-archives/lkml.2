Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757419Ab1EZJpv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 05:45:51 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54687 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757280Ab1EZJpu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 05:45:50 -0400
Message-ID: <4DDE2127.7090309@ti.com>
Date: Thu, 26 May 2011 10:45:11 +0100
From: Liam Girdwood <lrg@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "trivial@kernel.org" <trivial@kernel.org>
Subject: Re: [Patch][Trivial] sound, soc, codec, WM8915: Remove duplicate
 linux/delay.h inclusion.
References: <alpine.LNX.2.00.1105261028060.17400@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1105261028060.17400@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26/05/11 09:32, Jesper Juhl wrote:
> It's enough to include linux/delay.h just once in 
> sound/soc/codecs/wm8915.c, so remove the duplicate.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  wm8915.c |    1 -
>  1 file changed, 1 deletion(-)
> 
>  Patch against Linus' tree as of a few minutes ago.
> 
 Acked-by: Liam Girdwood <lrg@ti.com>
