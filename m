Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab1HMG1t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Aug 2011 02:27:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43643 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750791Ab1HMG1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Aug 2011 02:27:48 -0400
Date: Sat, 13 Aug 2011 15:27:39 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Richard Purdie <richard@openedhand.com>,
        Liam Girdwood <lrg@ti.com>, alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: wm8750: Fix missing braces around initializer
 warning
Message-ID: <20110813062737.GA16171@opensource.wolfsonmicro.com>
References: <1313207114.29596.6.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1313207114.29596.6.camel@phoenix>
X-Cookie: Do not overtax your powers.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 13, 2011 at 11:45:14AM +0800, Axel Lin wrote:
> Fix below warning:
>   CC      sound/soc/codecs/wm8750.o
> sound/soc/codecs/wm8750.c:784: warning: missing braces around initializer
> sound/soc/codecs/wm8750.c:784: warning: (near initialization for 'wm8750_spi_ids[2].name')

Takashi already made this change.
