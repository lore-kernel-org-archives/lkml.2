Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754384Ab2GFFZ5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 01:25:57 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:61023 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753329Ab2GFFZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 01:25:55 -0400
Date: Thu, 5 Jul 2012 22:25:51 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Daniel Kurtz <djkurtz@chromium.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: linux-next: manual merge of the input-mt tree with the
 input-current tree
Message-ID: <20120706052551.GB6804@core.coreip.homeip.net>
References: <20120705135220.9f8f95082833a0d6fadeb136@canb.auug.org.au>
 <CAGS+omDab9mOOf6pCryRTyLvYA66h0XjqmFPc-vrAo4hkfGN0A@mail.gmail.com>
 <20120705171904.GA31383@core.coreip.homeip.net>
 <20120705175723.GA3286@polaris.bitmath.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120705175723.GA3286@polaris.bitmath.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 07:57:23PM +0200, Henrik Rydberg wrote:
> On Thu, Jul 05, 2012 at 10:19:05AM -0700, Dmitry Torokhov wrote:
> > Hi Henrik,
> > 
> > On Thu, Jul 05, 2012 at 11:57:14AM +0800, Daniel Kurtz wrote:
> > > On Thu, Jul 5, 2012 at 11:52 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > > Hi Henrik,
> > > >
> > > > Today's linux-next merge of the input-mt tree got a conflict in
> > > > drivers/input/touchscreen/atmel_mxt_ts.c between commit 9b7e31bbf4bb
> > > > ("Input: request threaded-only IRQs with IRQF_ONESHOT") from the
> > > > input-current tree and commit c2ef9a1a248b ("Input: atmel_mxt_ts - use
> > > > client name for irq") from the input-mt tree.
> > > >
> > > > I fixed it up (see below) and can carry the fix as necessary.
> > > 
> > > Looks good to me. Don't know if you need it for a merge, but:
> > > 
> > > Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>
> > > 
> > 
> > Hmm, maybe it is time I pull your tree?
> 
> By all means, I have nothing further planned for the merge window. I
> wanted to wait until Linus pulls your current tree, then pull in the
> merge conflict, then eventual reverts, then send you a pull
> request. IOW, something like tomorrow. Sounds good?

You do not need to wait for Linus to pull and push: I will merge my
for-linus branch into next and pull and resolve your changes and then
git magic should take care of the rest.

So just send me a pull request.

Thanks.

-- 
Dmitry
