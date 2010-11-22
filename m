Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab0KVQFP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 11:05:15 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:38643 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756623Ab0KVQFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 11:05:12 -0500
Subject: Re: [PATCH v2] ASoC: atmel: test wrong variable
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Timur Tabi <timur@freescale.com>, Lars-Peter Clausen <lars@metafoo.de>,
        alsa-devel@alsa-project.org, Jarkko Nikula <jhnikula@gmail.com>
In-Reply-To: <20101122155913.GA9089@albatros>
References: <1290361216-15166-1-git-send-email-segoon@openwall.com>
	 <20101122094353.f76830b5.jhnikula@gmail.com>
	 <20101122155913.GA9089@albatros>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Nov 2010 16:05:01 +0000
Message-ID: <1290441901.3309.68.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-22 at 18:59 +0300, Vasiliy Kulikov wrote:
> After clk_get() mclk is checked second time instead of pllb check.
> In patch v1 Jarkko Nikula noticed that PTR_ERR() is also has wrong argument.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

