Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753968Ab1JBSob (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 14:44:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50290 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751716Ab1JBSoY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 14:44:24 -0400
Date: Sun, 2 Oct 2011 19:44:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 02/26] sound/pxa-zylonite: use a valid device for
 dev_err()
Message-ID: <20111002184417.GE2857@opensource.wolfsonmicro.com>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de>
 <1317499438-14058-3-git-send-email-arnd@arndb.de>
 <20111002181611.GA2857@opensource.wolfsonmicro.com>
 <2376094.AH5MH8IXqN@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2376094.AH5MH8IXqN@wuerfel>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 02, 2011 at 08:36:14PM +0200, Arnd Bergmann wrote:

> I also have a few sound/soc fixes in the respective samsung and
> omap series, so if you prefer I can move them to a sound/soc
> series and submit them all at once to you instead.

Please do.  It's probably not so important at this point in the release
cycle but we've got a tendency to run into cross tree issues with ASoC
and when it's not trivial build stuff I'd rather review anyway.

Please split the OMAP stuff out, Liam manages the tree for those when
he's available (though right now he's only intermittently online so I'm
applying those too).

> The subject line was hand-written, any problem in there is purely
> my own. What is the naming you want for sound/soc, should I use
> "ASoC: pxa-zylonite:" or "sound/soc/pxa/zylonite:" or something
> else?

ASoC: is the bit that I'm looking for.
