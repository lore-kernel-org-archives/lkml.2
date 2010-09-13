Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754853Ab0IMIlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 04:41:37 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:49268 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754784Ab0IMIlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 04:41:36 -0400
Date: Mon, 13 Sep 2010 09:41:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Baruch Siach <baruch@tkos.co.il>
Cc: Linus Walleij <linus.ml.walleij@gmail.com>,
        Christoph Lameter <cl@linux.com>, linux-arm-kernel@lists.infradead.org,
        linux kernel <linux-kernel@vger.kernel.org>,
        Jonas ?berg <jonas.aberg@stericsson.com>
Subject: Re: Regression on UP ARM from commit
	e18d65f0500b95d8724b17d8ea9f1116cf390bbe
Message-ID: <20100913084125.GI23903@sirena.org.uk>
References: <AANLkTimC5Vz7x9+MNJcewijoyw=Nyr6WWP=YR8cxqarH@mail.gmail.com> <20100913055549.GA14773@jasper.tkos.co.il>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100913055549.GA14773@jasper.tkos.co.il>
X-Cookie: Here there be tygers.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 07:55:49AM +0200, Baruch Siach wrote:
> Hi Linus,

> On Sun, Sep 12, 2010 at 11:47:39PM +0200, Linus Walleij wrote:
> > commit e18d65f0500b95d8724b17d8ea9f1116cf390bbe
> > "slub: Remove static kmem_cache_cpu array for boot"

> In which tree have you found this commit? I cant find 
> e18d65f0500b95d8724b17d8ea9f1116cf390bbe in Linus' (Torvalds) tree up to -rc4.

It's in -next via some means.
