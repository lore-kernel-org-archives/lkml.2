Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab2IPXoK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Sep 2012 19:44:10 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:33954 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960Ab2IPXoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Sep 2012 19:44:08 -0400
Date: Mon, 17 Sep 2012 00:43:56 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Will Deacon <will.deacon@arm.com>,
        Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH 06/24] ARM: integrator: use __iomem pointers for MMIO
Message-ID: <20120916234356.GB26353@n2100.arm.linux.org.uk>
References: <1347658492-11608-1-git-send-email-arnd@arndb.de> <1347658492-11608-7-git-send-email-arnd@arndb.de> <CACRpkdYsv7LJj=aJj3y-GhpAMD8PTKdLsYO8KATWevMM4F5MaQ@mail.gmail.com> <20120916223541.GA26353@n2100.arm.linux.org.uk> <CACRpkdbR+eOTkHHqQqJMSfui=Zn1vgehtXiJax-h5MkN6yK=tQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbR+eOTkHHqQqJMSfui=Zn1vgehtXiJax-h5MkN6yK=tQ@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 17, 2012 at 12:46:21AM +0200, Linus Walleij wrote:
> On Mon, Sep 17, 2012 at 12:35 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > On Mon, Sep 17, 2012 at 12:19:11AM +0200, Linus Walleij wrote:
> >>
> >> However if Russell applies some of the stuff that is pending
> >> in his tracker (was pending uncertain acceptance of
> >> CONFIG_ATAGS, which is merged now) this will likely
> >> conflict.
> >
> > I'm actually a little confused... 7514/1 apparantly has a comment from
> > me on it, but I don't remember making any comments against it - and the
> > comment is definitely crap for the patch.  I certainly wasn't processing
> > patches at 20:38 on Friday 7th, so, I'm wondering what's going on there.
> 
> I'm as confused as you are :-(
> 
> On some of the other patches I added a changelog, but this
> one doesn't have one, and I don't remember seeing that comment
> until now.
> 
> Do you want me to resubmit it as 7514/2?

No, I'll delete the comment and just apply it as is.
