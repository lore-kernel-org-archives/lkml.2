Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab1AXLQM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 06:16:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34970 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1AXLQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 06:16:11 -0500
Subject: Re: [alsa-devel] [PATCH] SoC: Samsung: Fix outdated cpu_dai_name
 for s3c24xx i2s
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        "for 2.6.37" <stable@kernel.org>
In-Reply-To: <1295735888-25527-2-git-send-email-lars@metafoo.de>
References: <1295735888-25527-1-git-send-email-lars@metafoo.de>
	 <1295735888-25527-2-git-send-email-lars@metafoo.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 24 Jan 2011 11:16:05 +0000
Message-ID: <1295867765.3419.6.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-01-22 at 23:38 +0100, Lars-Peter Clausen wrote:
> During the multi-component patch the s3c24xx i2s driver was renamed from
> "s3c24xx-i2s" to "s3c24xx-iis", while the sound board drivers were not
> updated to reflect this change as well.
> 
> As a result there is no match between the dai_link and the i2s driver and no
> sound card is instantiated.
> 
> This patch fixes the problem by updating the sound board drivers to use
> "s3c24xx-iis" for the cpu_dai_name.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> Cc: stable@kernel.org (for 2.6.37)

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

