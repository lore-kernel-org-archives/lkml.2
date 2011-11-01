Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753345Ab1KAKMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 06:12:31 -0400
Received: from ra.se.axis.com ([195.60.68.13]:42635 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752475Ab1KAKMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 06:12:30 -0400
Date: Tue, 1 Nov 2011 11:12:27 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Michal Marek <mmarek@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mikael Starvik <starvik@axis.com>,
        "Valdis.Kletnieks@vt.edu" <Valdis.Kletnieks@vt.edu>
Subject: Re: [PATCH 00/17] drop unused Kconfig symbols
Message-ID: <20111101101226.GI26898@axis.com>
References: <1319456255.2409.30.camel@x61.thuisdomein> <20111031224248.GB25411@sepie.suse.cz> <1320101716.14409.97.camel@x61.thuisdomein> <20111101085930.GF26898@axis.com> <1320140764.14409.135.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320140764.14409.135.camel@x61.thuisdomein>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 01, 2011 at 10:46:04AM +0100, Paul Bolle wrote:
> On Tue, 2011-11-01 at 09:59 +0100, Jesper Nilsson wrote:
> > On Mon, Oct 31, 2011 at 11:55:16PM +0100, Paul Bolle wrote:
> > > Just today Jesper Nilsson basically dropped that NAK. I assume Jesper
> > > will try to carry the patch in (one of) their tree(s). Is that correct?
> > 
> > The patch that reintroduces the Kconfigs, yes, the one that removes them, no.
> 
> But yesterday you wrote:
> On Fri, Oct 14, 2011 at 09:11:01PM +0200, Valdis.Kletnieks@vt.edu wrote:
> [...]
> > > (Personally, I'm tending towards unless it's going to be in linux-next within
> > > the next month or so, pull the Kconfig variables out and the driver can re-add
> > > them when it actually lands)
> > 
> > Ok, let's do it the right way and remove them now, and I can re-add
> > them in the same tree.
> 
> So your plans have changed? It's OK with me if they change, of course,
> but now I'm unsure what you intend to do.

Sorry, I was unclear and not complete in my sentence above.
I was referring above to the tree that the drivers will be added in,
not the one where the Kconfigs will be removed.

I assumed that the removal patch was handled elsewhere, so I didn't
pick up the original patch which removed them.

So, just to be clear on what I intend to do (now that I know what you meant):

- Pick up the removal patch to the CRIS-tree.
- Create a new tree/branch with the missing drivers and the Kconfigs readded.

Does this seem allright for you?

> Paul Bolle

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
