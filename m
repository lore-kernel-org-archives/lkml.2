Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752287Ab1LSEg2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 23:36:28 -0500
Received: from smtp22.mail.ru ([94.100.176.175]:51344 "EHLO smtp22.mail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752117Ab1LSEgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 23:36:25 -0500
Date: Mon, 19 Dec 2011 08:37:14 +0400
From: Dmitry Artamonow <mad_soft@inbox.ru>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Philipp Zabel <philipp.zabel@gmail.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: Re: ASoC: missed hx4700-audio platform device for hx4700
Message-ID: <20111219043713.GA6917@rainbow>
References: <1324114379.28427.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1324114379.28427.1.camel@phoenix>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Mru-NR: 8
X-Mru-UID: 1674633
X-Spam: Not detected
X-Mras: Ok
X-Mru-Karma: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17:32 Sat 17 Dec     , Axel Lin wrote:
> The iPAQ hx4700 machine driver needs a hx4700-audio platform device which is
> not (yet) merged.
> 
> The patchs was post on LKML: https://lkml.org/lkml/2011/5/18/222
> but [PATCH v3 3/3] pxa/hx4700: add platform device and I2C info for AK4641 codec is missed.

Hi, Axel! Thanks for noticing this. It's sad but true: this trivial
piece haven't been merged, making all merged  ASoC parts of hx4700 audio
support useless. In fact I even resend this patch once (see
http://lkml.org/lkml/2011/9/12/100), but also without much attention.
Have no idea what steps are needed to get this finally merged. I think
it all depends on Eric and he seems to be very busy and lost in incoming
mail (at least it was back in july - http://lkml.org/lkml/2011/7/11/217)

-- 
Best regards,
Dmitry "MAD" Artamonow

