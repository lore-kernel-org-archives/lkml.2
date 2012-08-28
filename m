Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab2H1Hs0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 03:48:26 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:37135 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab2H1HsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 03:48:25 -0400
Date: Tue, 28 Aug 2012 08:48:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        STEricsson_nomadik_linux@list.st.com, linus.walleij@stericsson.com,
        arnd@arndb.de, broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 13/22] ARM: ux500: Fork MSP platform registration for
 step-by-step DT enablement
Message-ID: <20120828074812.GA12957@gmail.com>
References: <1344527268-5964-1-git-send-email-lee.jones@linaro.org>
 <1344527268-5964-14-git-send-email-lee.jones@linaro.org>
 <CACRpkdaem6t3mvy-_9e=GEgwWoeBQSoX3Hf1L=hjWsvLJdsVAQ@mail.gmail.com>
 <20120820080632.GD8450@gmail.com>
 <CACRpkdZRJ1yX-o8-NUuMzXMz5ebbp=H21Xa6JMy1y56Chq-T9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACRpkdZRJ1yX-o8-NUuMzXMz5ebbp=H21Xa6JMy1y56Chq-T9g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 27, 2012 at 04:07:58PM -0700, Linus Walleij wrote:
> On Mon, Aug 20, 2012 at 1:06 AM, Lee Jones <lee.jones@linaro.org> wrote:
> > On Tue, Aug 14, 2012 at 01:13:49PM +0200, Linus Walleij wrote:
> >> On Thu, Aug 9, 2012 at 5:47 PM, Lee Jones <lee.jones@linaro.org> wrote:
> >>
> >> > We've done this before and it worked well last time. Here we're
> >> > duplicating a complex registration function to ease the process
> >> > of enabling it for Device Tree. As there are quite a few steps
> >> > taken during the registration process, it makes sense to break
> >> > them up into more manageable chunks. This patch will aid us.
> >> >
> >> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> >>
> >> I understand you have used this approach before so:
> >> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> >
> > Does this comment take back your previous one:
> >
> > NOTE: it seems this patch set contains some churn. First you
> > add in the forked device init, put in a big chunk of code and
> > then in the *same* patch set delete it again. It's not like
> > we're dying to see all the development history... can this
> > be squashed down a bit?
> >
> > ... hence leave the patch-set as it is?
> 
> No. I just meant leave it like that for the devices outside of this
> set.
> 
> If you're adding and then removing *all* of them in this set,
> why add them in the first place?

So that there's no breakage during bisection.

You should be able to roll the kernel back in between each of these
patches and there to be full compatibility at each point. At least
that was the intention. Is that wrong?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
