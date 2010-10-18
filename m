Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab0JRNzs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 09:55:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32756 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755160Ab0JRNzq (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 18 Oct 2010 09:55:46 -0400
Date: Mon, 18 Oct 2010 09:55:12 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        Xen Devel <Xen-devel@lists.xensource.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: linux-next: manual merge of the xen tree with the swiotlb-xen
 tree
Message-ID: <20101018135512.GA19999@dumpdata.com>
References: <20101018155249.d9267bfe.sfr@canb.auug.org.au>
 <4CBC014D.7070302@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBC014D.7070302@goop.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 01:11:57AM -0700, Jeremy Fitzhardinge wrote:
>  On 10/17/2010 09:52 PM, Stephen Rothwell wrote:
> > Hi all,
> >
> > Today's linux-next merge of the xen tree got conplex conflicts in
> > drivers/xen/events.c between several commits from the swiotlb-xen tree
> > and several commits from the xen tree.
> >
> > I am unqualified to fix this mess, sorry.  I am dropping the xen tree
> > for today (and only not dropping the swiotlb-xen tree because that would
> > be too much work).

Ugh. Let me revert the branch to pull this from to what it was a week ago.
That way Jeremy's tree should not have any trouble.

> 
> Argh, sorry, I should have coordinated with Konrad.  I'd merged my tree
> into linux-next to make sure it was OK, but I guess I overlooked something.
> 
> > I wonder, of course, why I have seen nothing in either of these trees
> > until today (less than a week before the merge window opens).

That is my fault. I thought the merge window was this _week_ so I happily
pushed the trigger button.

Since I seem to have a knack for making mistakes, let me get some clarification
so that I won't do it again.

When is it Ok for me to put in the #linux-next, new stable features (so
reviewed, acked, etc)? a) Is it post rc7? b) Or is it when Linus releases
the kernel and Linus's merge window opens?

I was thinking it is a), b/c if it would be b), then there is just two weeks
to fix any fallout that might happen due to merging of vast new features.

> 
> I had found Xen regressions that had made it into linux-next and wanted
> to sort those out before adding anything else to the mix.
> 
> > Please sort this mess out.  I will drop the swiotlb-xen tree as well
> > tomorrow if nothing has changed.
> 
> Will do.

Sorry about this. Will definitly work this out.

> 
> Thanks,
>     J
