Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863Ab0LGMir (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 07:38:47 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48918 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752505Ab0LGMiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 07:38:46 -0500
Subject: Re: [PATCH] ASoC: Fix snd_soc_instantiate_card error path
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
In-Reply-To: <1291712762.4776.11.camel@mola>
References: <1291712762.4776.11.camel@mola>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 12:38:42 +0000
Message-ID: <1291725522.3275.16.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-12-07 at 17:06 +0800, Axel Lin wrote:
> >From 0443551476ee6fabe45a0fbc7460dca8e0f6a965 Mon Sep 17 00:00:00 2001
> From: Axel Lin <axel.lin@gmail.com>
> Date: Tue, 7 Dec 2010 16:12:29 +0800
> Subject: [PATCH] ASoC: Fix snd_soc_instantiate_card error path
> 
> Properly free the resources in the case of snd_card_register failure
> and soc_register_ac97_dai_link failure.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>

> ---
> 
> This patch is against linux-next tree.
> 
> In the case of soc_register_ac97_dai_link failure,
> I think we need below fix for Linus's tree:
> Add 
> while (--i >= 0)
> 	soc_unregister_ac97_dai_link(&card->rtd[i]);
> just before goto probe_dai_err;
> Should I also send a patch against Linus's tree?
> 

Yes please.

Thanks

Liam



