Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753765Ab0FIGUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 02:20:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:23081 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752701Ab0FIGUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 02:20:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type;
	b=KgTg06VA20O3pM6A/YcmRNpCVwwAk38m0meswE/hdPNNXZDk3ASzc6O7uCNtmk3RI
	fsHxECD1mD4ajoAMpIDsw==
Date: Tue, 8 Jun 2010 23:20:40 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@cs.helsinki.fi>
cc: Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
       LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [RFC V2 SLEB 01/14] slab: Introduce a constant for a unspecified
 node.
In-Reply-To: <AANLkTimFmupRJ-np-V9TeiUNAqXmnyui3uYMs3PD1bWB@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1006082315100.28827@chino.kir.corp.google.com>
References: <20100521211452.659982351@quilx.com> <20100521211537.530913777@quilx.com> <alpine.DEB.2.00.1006071443120.10905@chino.kir.corp.google.com> <alpine.DEB.2.00.1006071729560.12482@router.home> <AANLkTikOKy6ZQQh2zORJDvGDE0golvyzsvlvDj-P5cur@mail.gmail.com>
 <alpine.DEB.2.00.1006072319330.31780@chino.kir.corp.google.com> <AANLkTikQhjlCPnwiK7AZo27Xb3h-Lj2JyCeqFQaVzpHX@mail.gmail.com> <alpine.DEB.2.00.1006081633450.19582@chino.kir.corp.google.com> <AANLkTimFmupRJ-np-V9TeiUNAqXmnyui3uYMs3PD1bWB@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Jun 2010, Pekka Enberg wrote:

> As I said, we can probably get away with that in slab.git because
> we're so small but that doesn't work in general.
> 
> If we ignore the fact how painful the actual rebase operation is
> (there's a 'sleb/core' branch that shares the commits), I don't think
> the revised history is 'cleaner' by any means. The current patches are
> known to be good (I've tested them) but if I just replace them, all
> the testing effort was basically wasted. So if I need to do a
> git-bisect, for example, I didn't benefit one bit from testing the
> original patches.
> 
> The other issue is patch metadata. If I just nuke the existing
> patches, I'm also could be dropping important stuff like Tested-by or
> Reported-by tags. Yes, I realize that in this particular case, there's
> none but the approach works only as long as you remember exactly what
> you merged.
> 
> There are probably other benefits for larger trees but those two are
> enough for me to keep my published branches append-only.
> 

I wasn't really trying to suggest an alternative way to do it for all git 
trees, I just thought that since Christoph wanted to repropose these 
changes in another set and given there's no harm in doing it within 
slab.git right now that you'd have no problem making an exception in this 
case just for a cleaner history later.

If you'd like to keep a commit that is then completely obsoleted by 
another commit when it's on the tip of your tree right now and could 
be reverted with minimal work simply to follow this general principle, 
that's fine :)

> > Let me know if my suggested changes should be add-on patches to
> > Christoph's first five and I'll come up with a three patch series to do
> > just that.
> 
> Yes, I really would prefer incremental patches on top of the
> 'slub/cleanups' branch.
> 

Ok then, I'll send incremental changes based on my feedback of patches 
1-5.  Thanks!
