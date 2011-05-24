Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756101Ab1EXAIv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 20:08:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57374 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751883Ab1EXAIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 20:08:49 -0400
Date: Tue, 24 May 2011 08:08:43 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: x86@kernel.org, Stephen Rothwell <sfr@canb.auug.org.au>,
        alsa-devel@alsa-project.org, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Harald Welte <laforge@gnufiish.org>,
        Dmitry Artamonow <mad_soft@inbox.ru>
Subject: Re: linux-next: Tree for May 23 (sound/soc/codecs)
Message-ID: <20110524000837.GA30515@opensource.wolfsonmicro.com>
References: <20110523154518.5e27cfb0.sfr@canb.auug.org.au>
 <20110523134815.fb87933a.randy.dunlap@oracle.com>
 <20110523224659.GB19533@opensource.wolfsonmicro.com>
 <20110523155343.2e68c265.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110523155343.2e68c265.randy.dunlap@oracle.com>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 03:53:43PM -0700, Randy Dunlap wrote:
> On Tue, 24 May 2011 06:47:28 +0800 Mark Brown wrote:

> > case, please talk to the architecture maintainers about this - it's an
> > issue in the architecture GPIO support (or lack thereof) rather than a
> > driver problem.

> except that a driver should not assume that defines like
> GPIOF_OUT_INIT_LOW are always available.

No, really we should.  The GPIO APIs are stubbed out when not in use for
a very good reason, think about the usability here.  The goal here isn't
to litter the code with ifdefs - if architectures aren't able to keep up
with API changes they should convert to using gpiolib so this stuff
happens automatically (indeed, I can't think of any good reason for an
architecture to not be using gpiolib at this point).

> > Also adding Dmitry who submitted the driver - Randy, please try to
> > remember to CC relevant people.

> Which driver did Dmitry submit?  how would I know that?
> I don't download every linux-next git tree -- just linux-next tarballs.

I *strongly* suggest looking at git if you want to find relevant people
to mail; the internal documentation in the code really isn't a terribly
useful guide, the authors listed in the code often bear no relation to
who's actually working on it at the current time.

> and wm8915.c says:
> MODULE_AUTHOR("Mark Brown <broonie@opensource.wolfsonmicro.com>");

You've clearly not looked at MAINTAINERS for this one.
