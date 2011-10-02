Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754474Ab1JBTtM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Oct 2011 15:49:12 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59871 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab1JBTtJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Oct 2011 15:49:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-arm-kernel@lists.infradead.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, Jason Chagas <jason.chagas@marvell.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Eric Miao <eric.y.miao@gmail.com>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 02/26] sound/pxa-zylonite: use a valid device for dev_err()
Date: Sun, 02 Oct 2011 21:48:13 +0200
Message-ID: <11180812.GzalXgfRcs@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.0.0-rc1nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <20111002184417.GE2857@opensource.wolfsonmicro.com>
References: <1317499438-14058-1-git-send-email-arnd@arndb.de> <2376094.AH5MH8IXqN@wuerfel> <20111002184417.GE2857@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:OowSiTQY7sQPIhz+BHhUAm+RatqLzcZ0qDN1hfJoyCr
 pqlQY3iYkzxl+em59Sui5pzdi9/ZtLNX3r7Y9QBNz/zx8sB+r6
 Gzx4t+mLgoRvRvr2UAomNcIwwSdJbRJ9ZrDn/hYJhkaxloGMvv
 uvVpH5J8WGs+jOfM09GPEN9DUxQZO521iHnVlNH5wAkdWyNuQ8
 GuSIqN9lnC/6XUUQJnkBhy4FsNKZT9zruECGtSSKGv0TVuBGEq
 5wbQzfz8aDnpCC+pPaZ44Joefpxp3nNQeFePPayQdFAUsYJQbE
 TJUcxQPp6NKITiqX4oxIndZfJ0/m4KQqoiJ9Sz13hWdoBthbet
 fvp9D8ek9zurxOG7ze/c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 October 2011 19:44:17 Mark Brown wrote:
> On Sun, Oct 02, 2011 at 08:36:14PM +0200, Arnd Bergmann wrote:
> 
> > I also have a few sound/soc fixes in the respective samsung and
> > omap series, so if you prefer I can move them to a sound/soc
> > series and submit them all at once to you instead.
> 
> Please do.  It's probably not so important at this point in the release
> cycle but we've got a tendency to run into cross tree issues with ASoC
> and when it's not trivial build stuff I'd rather review anyway.
> 
> Please split the OMAP stuff out, Liam manages the tree for those when
> he's available (though right now he's only intermittently online so I'm
> applying those too).

Almost all the patches I have are both trivial and unimportant corner
cases. I'm removing the ones I have from all the other branches now
and will try to get them to you both asap.

> > The subject line was hand-written, any problem in there is purely
> > my own. What is the naming you want for sound/soc, should I use
> > "ASoC: pxa-zylonite:" or "sound/soc/pxa/zylonite:" or something
> > else?
> 
> ASoC: is the bit that I'm looking for.

Ok, got it.

	Arnd
