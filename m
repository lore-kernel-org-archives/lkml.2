Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755343Ab1CKVmO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 16:42:14 -0500
Received: from fieldses.org ([174.143.236.118]:49457 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754529Ab1CKVmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 16:42:12 -0500
Date: Fri, 11 Mar 2011 16:42:09 -0500
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: David Miller <davem@davemloft.net>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
Message-ID: <20110311214209.GB9404@fieldses.org>
References: <20110310.155556.48513201.davem@davemloft.net>
 <AANLkTik3AyFTNoytebmOOZ=JSFMkt0bw7au-CSncUHJu@mail.gmail.com>
 <20110311204823.GB7906@fieldses.org>
 <20110311.130128.71121155.davem@davemloft.net>
 <1299878274.2814.8.camel@bwh-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299878274.2814.8.camel@bwh-desktop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 11, 2011 at 09:17:54PM +0000, Ben Hutchings wrote:
> On Fri, 2011-03-11 at 13:01 -0800, David Miller wrote:
> > From: "J. Bruce Fields" <bfields@fieldses.org>
> > Date: Fri, 11 Mar 2011 15:48:23 -0500
> > 
> > > As with the above, it'd make the history a little more self-documenting.
> > 
> > Once there is even one single commit after the buggy one, this is
> > simply impossible since the hashes of subsequent commits depend upon
> > the precise contents of the original one.
> 
> I think Bruce is suggesting that the fix is committed on a branch from
> the broken commit, then merged into whatever branches need it.  I'm not
> sure how much that helps, though.  The merge could then involve forward-
> porting (as opposed to the current situation where fixes are cherry-
> picked and possibly back-ported).

Yeah, there could be merge conflicts.

But assume you only did this in cases where the merge was trivial.
Would it be worth it, or would people be annoyed by the additional
branching?

--b.
