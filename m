Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2EPEwM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 00:52:12 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:63296 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab2EPEwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 00:52:09 -0400
Date: Wed, 16 May 2012 06:52:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnaud Lacombe <lacombar@gmail.com>,
        Nick Bowler <nbowler@elliptictech.com>,
        Richard Weinberger <richard@nod.at>
Subject: Re: [PATCH 0/8] kbuild: use script for final link, move
	definitions out of top-level Makefile
Message-ID: <20120516045208.GB340@merkur.ravnborg.org>
References: <20120505080640.GA13773@merkur.ravnborg.org> <4FA57F52.5070808@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA57F52.5070808@suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 05, 2012 at 09:28:18PM +0200, Michal Marek wrote:
> Dne 5.5.2012 10:06, Sam Ravnborg napsal(a):
> > Hi Michal, all.
> > 
> > o Move the link of vmlinux from top-level Makefile to a script.
> >   This increased the readability a lot.
> >   They have had a few rounds of reviews and are ready.
> > 
> > o Move a lot of definitions from top-level Makefile to
> >   two new files located in scripts/
> > 
> > o Fix so we do not call CC too often when using W=...
> > 
> > o Fix so KCFLAGS (and friends) are added last to the
> >   command lines.
> > 
> > Patches 1-4 are ready to be applied.
> > Patches 5-8 are new and may raise a few comments.
> 
> I merged 1-4 now, I'll look at the rest later.

Hi Michal.

We are too close to the merge window to
apply patch 5-8.

I plan to resubmit them around -rc2 time,
then we should have time for review
and test.

Any comments until then are of course welcome,
but I expect you to wait until next submission.

	Sam
