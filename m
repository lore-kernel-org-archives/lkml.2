Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014Ab0FDKiY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 06:38:24 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:47356 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750822Ab0FDKiW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 06:38:22 -0400
Date: Fri, 4 Jun 2010 12:38:20 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Nicolas Palix <npalix@diku.dk>
Cc: Michal Marek <mmarek@suse.cz>, Randy Dunlap <rdunlap@xenotime.net>,
       Roland Dreier <rdreier@cisco.com>, Joe Perches <joe@perches.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "David S. Miller" <davem@davemloft.net>, Julia Lawall <julia@diku.dk>,
       Gilles Muller <Gilles.Muller@lip6.fr>, linux-kernel@vger.kernel.org,
       linux-kbuild@vger.kernel.org, cocci@diku.dk,
       Wolfram Sang <w.sang@pengutronix.de>,
       Kernel Janitors <kernel-janitors@vger.kernel.org>
Subject: Re: [PATCH 1/4] Add targets to use the Coccinelle checker
Message-ID: <20100604103820.GA10104@merkur.ravnborg.org>
References: <1273508667-5152-1-git-send-email-npalix@diku.dk> <1273508667-5152-2-git-send-email-npalix@diku.dk> <20100603102315.GA8002@merkur.ravnborg.org> <201006041156.20714.npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006041156.20714.npalix@diku.dk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > A nice simplification of the top-level Mkefile.
> > and an opportunity to document some of the
> > magic shell commands used by the various tools.
...
> 
> I am not sure to understand your suggestion.
> 
> Should I make this change and integrate it into my patch series
> or it is something to do later ?

If we agree on this as the base infrastructure I would
like you to introduce it as part of adding Coccinelle support.

That should not touch the existing targets - but only
add Coccinelle support. But in a way so we have the
infrastructure in place so we can later move the other targets later.

> 
> In doing so, I will have to select the 'mode' in a different way.
> I was thinking of renaming my targets in one of the following forms
> or using an environment variable:
> 
> make cocci-report-check
> make report-coccicheck
> make coccicheck MODE=report

I like the latter.
If you do "make coccicheck" then you can show a list of
possible mode's. And if MODE is set you use this mode.

	Sam
