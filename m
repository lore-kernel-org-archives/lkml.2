Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754261Ab1HDNk7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 09:40:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41627 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753382Ab1HDNk5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 09:40:57 -0400
Date: Thu, 4 Aug 2011 22:40:47 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org,
        bernd@petrovitsch.priv.at
Subject: Re: [PATCH 1/4] regulator: tps65023: Fixes i2c configuration issues
Message-ID: <20110804134045.GB10451@opensource.wolfsonmicro.com>
References: <marcus.folkesson@gmail.com>
 <1312457632-27075-1-git-send-email-marcus.folkesson@gmail.com>
 <1312457632-27075-2-git-send-email-marcus.folkesson@gmail.com>
 <20110804121331.GB9959@opensource.wolfsonmicro.com>
 <4E3AA111.1030002@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3AA111.1030002@gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 03:39:29PM +0200, Marcus Folkesson wrote:
> Changes:
> -#define TPS65023_REG_CTRL2_DCDC1	BIT(2)
> +#define TPS65023_REG_CTRL2_DCDC1	BIT(1)
> 
> Thank you Bernd Petrovitsch for mention it!

Please submit patches in the format documented in SubmittingPatches.

but

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
