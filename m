Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab0KVU1L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 15:27:11 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45294 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751457Ab0KVU1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 15:27:10 -0500
Date: Mon, 22 Nov 2010 20:27:07 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, Timur Tabi <timur@freescale.com>,
        Lars-Peter Clausen <lars@metafoo.de>, alsa-devel@alsa-project.org,
        Jarkko Nikula <jhnikula@gmail.com>
Subject: Re: [PATCH v2] ASoC: atmel: test wrong variable
Message-ID: <20101122202705.GA577@rakim.wolfsonmicro.main>
References: <1290361216-15166-1-git-send-email-segoon@openwall.com>
 <20101122094353.f76830b5.jhnikula@gmail.com>
 <20101122155913.GA9089@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101122155913.GA9089@albatros>
X-Cookie: Generic Fortune.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 22, 2010 at 06:59:13PM +0300, Vasiliy Kulikov wrote:
> After clk_get() mclk is checked second time instead of pllb check.
> In patch v1 Jarkko Nikula noticed that PTR_ERR() is also has wrong argument.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Applied, thanks.
