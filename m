Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752795Ab1AXMHs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 07:07:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58778 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752566Ab1AXMHr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 07:07:47 -0500
Date: Mon, 24 Jan 2011 12:07:45 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, "for 2.6.37" <stable@kernel.org>
Subject: Re: [PATCH] SoC: Samsung: Fix outdated cpu_dai_name for s3c24xx i2s
Message-ID: <20110124120744.GC29925@opensource.wolfsonmicro.com>
References: <1295735888-25527-1-git-send-email-lars@metafoo.de>
 <1295735888-25527-2-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1295735888-25527-2-git-send-email-lars@metafoo.de>
X-Cookie: Keep it short for pithy sake.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 22, 2011 at 11:38:08PM +0100, Lars-Peter Clausen wrote:
> During the multi-component patch the s3c24xx i2s driver was renamed from
> "s3c24xx-i2s" to "s3c24xx-iis", while the sound board drivers were not
> updated to reflect this change as well.
> 
> As a result there is no match between the dai_link and the i2s driver and no
> sound card is instantiated.
> 
> This patch fixes the problem by updating the sound board drivers to use
> "s3c24xx-iis" for the cpu_dai_name.

This patch doesn't apply, git am says:

Applying: SoC: Samsung: Fix outdated cpu_dai_name for s3c24xx i2s
error: patch failed: sound/soc/samsung/neo1973_wm8753.c:559
error: sound/soc/samsung/neo1973_wm8753.c: patch does not apply
error: patch failed: sound/soc/samsung/s3c24xx_simtec_hermes.c:85
error: sound/soc/samsung/s3c24xx_simtec_hermes.c: patch does not apply
error: patch failed: sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c:74
error: sound/soc/samsung/s3c24xx_simtec_tlv320aic23.c: patch does not apply
Patch failed at 0001 SoC: Samsung: Fix outdated cpu_dai_name for s3c24xx i2s

Please submit fixes against the current fix branch, currently 2.6.38.
