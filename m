Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753121Ab1HNKY0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Aug 2011 06:24:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47385 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752659Ab1HNKYZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Aug 2011 06:24:25 -0400
Date: Sun, 14 Aug 2011 19:24:10 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org,
        device-drivers-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Mike Frysinger <vapier.adi@gmail.com>
Subject: Re: [PATCH 2/4] ASoC: Add ADAU1373 codec support
Message-ID: <20110814102407.GB18382@opensource.wolfsonmicro.com>
References: <1312948364-2587-1-git-send-email-lars@metafoo.de>
 <1312948364-2587-2-git-send-email-lars@metafoo.de>
 <20110811092702.GA18454@opensource.wolfsonmicro.com>
 <4E43AACF.5060701@metafoo.de>
 <1313068590.19990.2.camel@finisterre.wolfsonmicro.main>
 <4E4471E1.5060706@metafoo.de>
 <1313112046.19990.32.camel@finisterre.wolfsonmicro.main>
 <4E45EEB5.8080107@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E45EEB5.8080107@metafoo.de>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 13, 2011 at 05:25:41AM +0200, Lars-Peter Clausen wrote:

> Since this driver's DAPM already doesn't distinguish between the left and the
> right channel of the input bypass signals none of the outputs or mixers are not
> powered when they should be.
> 
> So I would like to keep these as enums, as they are right now.

OK.
