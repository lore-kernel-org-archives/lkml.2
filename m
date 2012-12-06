Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932473Ab2LFJlL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 04:41:11 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49276 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932232Ab2LFJlI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 04:41:08 -0500
Date: Thu, 6 Dec 2012 10:41:01 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Nadia Yvette Chambers <nyc@holomorphy.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [patch] propagate name change to comments in kernel source
In-Reply-To: <1354756634.9720.203.camel@tisifone>
Message-ID: <alpine.LNX.2.00.1212061040350.28002@pobox.suse.cz>
References: <1354754668.9720.198.camel@tisifone>  <20121206120148.99919a3512c72947c8baba67@canb.auug.org.au> <1354756634.9720.203.camel@tisifone>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 5 Dec 2012, Nadia Yvette Chambers wrote:

> > OK, that may be a problem.  Does this patch apply to Linus' tree
> > currently?  I guess not.  So, either you need to split it up and send it
> > to the various maintainers (most if it can probably go through the trivial
> > tree (cc'd)).  Or wait until after v3.8-rc1 and fix it so it applies to
> > Linus' tree and send it to him.
> > Or Andrew (cc'd) may be able to take it (as his tree is based on
> > linux-next currently).
> > (I have attached the patch for Jiri's and Andrew's benefit)
> 
> It applies with offsets to Linus' current git, actually. I can provide a
> diff applying with no offsets, but suspect it's unnecessary. The
> affected comment blocks don't seem to have experienced much turnover
> recently, if ever.

Yup, it applies cleanly. I have taken it.

-- 
Jiri Kosina
SUSE Labs
