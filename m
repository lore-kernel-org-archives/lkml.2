Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab1HONwx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 09:52:53 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44689 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753153Ab1HONww (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 09:52:52 -0400
Date: Mon, 15 Aug 2011 22:52:45 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: soc-cache: Remove unneeded codec_drv pointer
 variable in snd_soc_flat_cache_init
Message-ID: <20110815135242.GB5890@opensource.wolfsonmicro.com>
References: <1313241121.12301.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313241121.12301.2.camel@phoenix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 13, 2011 at 09:12:01PM +0800, Axel Lin wrote:
> Since commit d779fce5d79525d66269c8f6e430e1515d697f3d
> "ASoC: soc-cache: Ensure flat compression uses a copy of the defaults cache",
> the codec_drv pointer variable is not used any more.

Applied, thanks.
