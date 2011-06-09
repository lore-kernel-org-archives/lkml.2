Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751656Ab1FIOIH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 10:08:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43651 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750899Ab1FIOIF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 10:08:05 -0400
Date: Thu, 9 Jun 2011 15:08:03 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [PATCH] ASoC: snd_soc_new_{mixer,mux,pga} make sure to use right
 DAPM context
Message-ID: <20110609140802.GF12865@opensource.wolfsonmicro.com>
References: <1307618556-32068-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307618556-32068-1-git-send-email-lars@metafoo.de>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 09, 2011 at 01:22:36PM +0200, Lars-Peter Clausen wrote:
> Currently it is possible that snd_soc_new_{mixer,mux,pga} is called with a
> DAPM context not matching the widgets context. This can lead to a wrong
> prefix_len calculation, which will result in undefined behaviour. To avoid
> this always use the DAPM context from the widget itself.

Applied, thanks.
