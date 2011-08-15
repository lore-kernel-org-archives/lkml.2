Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab1HONxO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 09:53:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44695 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753587Ab1HONxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 09:53:13 -0400
Date: Mon, 15 Aug 2011 22:53:05 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: soc-cache: Remove unneeded codec_drv pointer
 variable in snd_soc_lzo_get_blksize
Message-ID: <20110815135302.GC5890@opensource.wolfsonmicro.com>
References: <1313242036.12301.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313242036.12301.4.camel@phoenix>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 13, 2011 at 09:27:16PM +0800, Axel Lin wrote:
> Since commit aea170a099793abcd0e6de46b947458073204241
> "ASoC: soc-cache: Add reg_size as a member to snd_soc_codec",
> the codec_drv pointer variable is not used in snd_soc_lzo_get_blksize.

Applied, thanks.
