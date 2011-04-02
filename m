Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756868Ab1DBTlR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 15:41:17 -0400
Received: from fieldses.org ([174.143.236.118]:50251 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756239Ab1DBTlQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 15:41:16 -0400
Date: Sat, 2 Apr 2011 15:40:59 -0400
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: Andi Kleen <andi@firstfloor.org>, mijinlong@cn.fujitsu.com,
        ak@linux.intel.com, bfields@redhat.com, gregkh@suse.de,
        linux-kernel@vger.kernel.org, stable@kernel.org, tim.bird@am.sony.com
Subject: Re: [PATCH] [232/275] nfsd: wrong index used in inner loop
Message-ID: <20110402194059.GB8960@fieldses.org>
References: <20110330203.501921634@firstfloor.org>
 <20110330210757.F3D223E1A05@tassilo.jf.intel.com>
 <4D93A6F4.60206@msgid.tls.msk.ru>
 <4D93A8F9.2080407@msgid.tls.msk.ru>
 <20110330233328.GH21838@one.firstfloor.org>
 <4D9422B0.2020003@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9422B0.2020003@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 10:44:00AM +0400, Michael Tokarev wrote:
> 31.03.2011 03:33, Andi Kleen wrote:
> >> Doh, so this 232/275 basically reverts that 180 and makes
> >> other change down the line, but keeps the subject intact.
> >> Especially useful that the two patches are so far away
> >> from each other (more than 50 patches in-between).
> >> Confusing :)
> >>
> >> So both are actually needed, apparently.
> > 
> > Sorry about that -- i ended up grabbing those from .32 and since
> > there were multiple releases in sequence it ended up this way.
> 
> It's definitely not your fault -- second patch should be
> named differently (since it does something else) but it's
> not.
> 
> > I can collapse the two patches.
> 
> Just be careful they don't end in the same _file_.  In
> the gregkh's stable-queue repository each patch is keept
> in a separate file named after the subject line, so that
> means just that - the same file.
> 
> > Are the leftover hunks after that good?
> 
> I remember original discussion when first patch has been
> posted (was fun to read the original code), but I missed
> second half of it.  So I re-read it and found the second
> part now, all is ok with it and with the resulting two-
> patch solution, except of the possible "patch name" clash,
> which may only when organizing patches in a plain directory.
> 
> Anyway, that's a good story I think, and the conclusion is -
> please name your patches correctly :)

Apologies, my fault--thanks for sorting it out.

--b.
