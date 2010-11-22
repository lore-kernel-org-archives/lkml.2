Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756080Ab0KVOAG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Nov 2010 09:00:06 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46295 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752060Ab0KVOAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Nov 2010 09:00:04 -0500
Date: Mon, 22 Nov 2010 14:00:02 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Vasiliy Kulikov <segoon@openwall.com>
Cc: kernel-janitors@vger.kernel.org, Jassi Brar <jassi.brar@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.de>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: s3c24xx: test wrong variable
Message-ID: <20101122140002.GB18960@rakim.wolfsonmicro.main>
References: <1290361223-15211-1-git-send-email-segoon@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290361223-15211-1-git-send-email-segoon@openwall.com>
X-Cookie: Must be under 48 inches in height.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 21, 2010 at 08:40:21PM +0300, Vasiliy Kulikov wrote:
> After clk_get() mclk is checked three times instead of mout_epll
> and sclk_spdif checks.
> 
> Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>

Applied, thanks.
