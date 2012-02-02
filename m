Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753442Ab2BBAKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 19:10:10 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53790 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052Ab2BBAKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 19:10:07 -0500
Date: Wed, 1 Feb 2012 17:10:05 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Barry Song <21cnbao@gmail.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        workgroup.linux@csr.com, linux-mtd@lists.infradead.org,
        Atsushi Nemoto <anemo@mba.ocn.ne.jp>, Barry Song <Baohua.Song@csr.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Erik Gilling <konkers@google.com>, Barry Song <Barry.Song@csr.com>
Subject: Re: [PATCH 1/3] platform: add common resource requesting and mapping
 helper
Message-ID: <20120202001005.GB15343@ponder.secretlab.ca>
References: <1328004002-24646-1-git-send-email-Barry.Song@csr.com>
 <1328004002-24646-2-git-send-email-Barry.Song@csr.com>
 <20120131101734.GE2471@pengutronix.de>
 <CAGsJ_4wyJ6Wymy4AWoW1eHubZX=W7GT_Fbow9ofXoY1RrcHzgA@mail.gmail.com>
 <20120131113358.GM2471@pengutronix.de>
 <20120131203455.GG22611@ponder.secretlab.ca>
 <20120131211554.GA28105@pengutronix.de>
 <CAGsJ_4yJZYHUzr9YerdM5o8grGd6iP51ra4nJkMuOo5Khn95RQ@mail.gmail.com>
 <20120201125642.GC13723@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120201125642.GC13723@sirena.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 12:56:42PM +0000, Mark Brown wrote:
> On Wed, Feb 01, 2012 at 10:11:10AM +0800, Barry Song wrote:
> 
> > i think it makes sense for us to have platform_devm_request_irq() and
> > similar things. i'll take care.
> 
> Note that this one is more tricky than most as it's really important
> that the interrupt handler can't be called when the data it needs and so
> on have been freed.  With things like memory this really doesn't matter
> and you can happily free in any order.

Good point.

g.

