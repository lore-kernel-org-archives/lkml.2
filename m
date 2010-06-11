Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760048Ab0FKJu5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 05:50:57 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:37513 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab0FKJu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 05:50:56 -0400
Subject: Re: [PATCH] ASoC: Remove unused header
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Herb Peyerl <hpeyerl@beer.org>, alsa-devel@alsa-project.org,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       linux-kernel@vger.kernel.org, Jon Smirl <jonsmirl@gmail.com>
In-Reply-To: <20100610235348.29652.91350.stgit@angua>
References: <20100610235348.29652.91350.stgit@angua>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Jun 2010 10:50:40 +0100
Message-ID: <1276249840.3242.0.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-06-10 at 17:54 -0600, Grant Likely wrote:
> The header contains an extern that isn't used by anything.  Remove.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
> Cc: Liam Girdwood <lrg@slimlogic.co.uk>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Jon Smirl <jonsmirl@gmail.com>
> Cc: Herb Peyerl <hpeyerl@beer.org>
> ---
>  sound/soc/fsl/mpc5200_psc_i2s.c |    1 -
>  sound/soc/fsl/mpc5200_psc_i2s.h |   12 ------------
>  2 files changed, 0 insertions(+), 13 deletions(-)
>  delete mode 100644 sound/soc/fsl/mpc5200_psc_i2s.h

Acked-by: Liam Girdwood <lrg@slimlogic.co.uk>
-- 
Freelance Developer, SlimLogic Ltd
ASoC and Voltage Regulator Maintainer.
http://www.slimlogic.co.uk

