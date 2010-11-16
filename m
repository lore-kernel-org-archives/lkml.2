Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932875Ab0KPJww (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 04:52:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47346 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932489Ab0KPJwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 04:52:51 -0500
Subject: Re: [PATCH 0/5] ASoC: Fix incorrect kfree in error path
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Barry Song <21cnbao@gmail.com>,
        Vladimir Barinov <vbarinov@embeddedalley.com>,
        Richard Purdie <richard@openedhand.com>
In-Reply-To: <1289894800.19543.2.camel@mola>
References: <1289894800.19543.2.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Nov 2010 09:52:45 +0000
Message-ID: <1289901165.3338.12.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-16 at 16:06 +0800, Axel Lin wrote:
> This serial of patches fixes incorrect kfree in error path.
> 
> Axel Lin (5):
>   ASoC: Fix incorrect kfree in ad1836_probe error path
>   ASoC: Fix incorrect kfree in ad193x_probe error path
>   ASoC: Fix incorrect kfree in aic3x_probe error path
>   ASoC: Fix incorrect kfree in wm8731_probe error path
>   ASoC: Fix incorrect kfree in wm8962_probe error path
> 
>  sound/soc/codecs/ad1836.c      |    1 -
>  sound/soc/codecs/ad193x.c      |    1 -
>  sound/soc/codecs/tlv320aic3x.c |    1 -
>  sound/soc/codecs/wm8731.c      |    1 -
>  sound/soc/codecs/wm8962.c      |    1 -
>  5 files changed, 0 insertions(+), 5 deletions(-)
> 
All 

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

