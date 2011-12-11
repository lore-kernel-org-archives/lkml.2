Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab1LKDEC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 22:04:02 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57513 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751363Ab1LKDEA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 22:04:00 -0500
Date: Sun, 11 Dec 2011 11:03:18 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lothar =?iso-8859-1?Q?Wa=DFmann?= <LW@KARO-electronics.de>
Cc: alsa-devel@alsa-project.org, Dong Aisheng-B29396 <B29396@freescale.com>,
        linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/5] ASoC: mxs: General cleanups
Message-ID: <20111211030316.GG2800@opensource.wolfsonmicro.com>
References: <cover.1323436034.git.LW@KARO-electronics.de>
 <992d017bd0214a67a836f2d0279b4edb6913da28.1323436034.git.LW@KARO-electronics.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <992d017bd0214a67a836f2d0279b4edb6913da28.1323436034.git.LW@KARO-electronics.de>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 09, 2011 at 02:38:08PM +0100, Lothar Waﬂmann wrote:
> Some textual cleanups without functional changes
> 
> Signed-off-by: Lothar Waﬂmann <LW@KARO-electronics.de>
> ---
>  sound/soc/codecs/sgtl5000.c |   13 ++++++-------
>  sound/soc/mxs/mxs-saif.c    |    2 +-

This is mostly a patch to a CODEC driver not anything to do with mxs as
the subject says and 

>  static const struct i2c_device_id sgtl5000_id[] = {
>  	{"sgtl5000", 0},
> -	{},
> +	{ /* sentinel */ }

I'm not sure I actually find that an improvement; if we're going to
actively go out and do that we should do it consistently.
