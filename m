Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004Ab2GER45 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 13:56:57 -0400
Received: from smtprelay-b12.telenor.se ([62.127.194.21]:55603 "EHLO
	smtprelay-b12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752814Ab2GER4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 13:56:55 -0400
X-SENDER-IP: [85.230.168.62]
X-LISTENER: [smtp.bredband.net]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AilUAMrU9U9V5qg+PGdsb2JhbABFihqtFRkBAQEBHgMWDSeCGAEBBTocIxAIAxguFCUKGhOID7lfFIslhV5gA5U2hWaMfw
X-IronPort-AV: E=Sophos;i="4.77,532,1336341600"; 
   d="scan'208";a="372100225"
From: "Henrik Rydberg" <rydberg@euromail.se>
Date: Thu, 5 Jul 2012 19:57:23 +0200
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Daniel Kurtz <djkurtz@chromium.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: linux-next: manual merge of the input-mt tree with the
 input-current tree
Message-ID: <20120705175723.GA3286@polaris.bitmath.org>
References: <20120705135220.9f8f95082833a0d6fadeb136@canb.auug.org.au>
 <CAGS+omDab9mOOf6pCryRTyLvYA66h0XjqmFPc-vrAo4hkfGN0A@mail.gmail.com>
 <20120705171904.GA31383@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120705171904.GA31383@core.coreip.homeip.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 05, 2012 at 10:19:05AM -0700, Dmitry Torokhov wrote:
> Hi Henrik,
> 
> On Thu, Jul 05, 2012 at 11:57:14AM +0800, Daniel Kurtz wrote:
> > On Thu, Jul 5, 2012 at 11:52 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > Hi Henrik,
> > >
> > > Today's linux-next merge of the input-mt tree got a conflict in
> > > drivers/input/touchscreen/atmel_mxt_ts.c between commit 9b7e31bbf4bb
> > > ("Input: request threaded-only IRQs with IRQF_ONESHOT") from the
> > > input-current tree and commit c2ef9a1a248b ("Input: atmel_mxt_ts - use
> > > client name for irq") from the input-mt tree.
> > >
> > > I fixed it up (see below) and can carry the fix as necessary.
> > 
> > Looks good to me. Don't know if you need it for a merge, but:
> > 
> > Reviewed-by: Daniel Kurtz <djkurtz@chromium.org>
> > 
> 
> Hmm, maybe it is time I pull your tree?

By all means, I have nothing further planned for the merge window. I
wanted to wait until Linus pulls your current tree, then pull in the
merge conflict, then eventual reverts, then send you a pull
request. IOW, something like tomorrow. Sounds good?

Henrik
