Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754763Ab1JMKuz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:50:55 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42949 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754277Ab1JMKuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:50:54 -0400
Date: Thu, 13 Oct 2011 11:50:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: pxa: Remove redundant snd_soc_dapm_sync() calls
 from machine drivers
Message-ID: <20111013105052.GB5193@opensource.wolfsonmicro.com>
References: <1318462736.17043.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1318462736.17043.1.camel@phoenix>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 07:38:56AM +0800, Axel Lin wrote:
> The core will sync DAPM as part of the card initialization, there is no
> need for machine drivers to do so during their setup.

Applied, thanks.
