Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236Ab2GCQ0R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 12:26:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61622 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932106Ab2GCQ0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 12:26:15 -0400
Date: Tue, 3 Jul 2012 13:26:07 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: RFD: virtio balloon API use (was Re: [PATCH 5 of 5] virtio:
 expose added descriptors immediately)
Message-ID: <20120703162606.GA1727@t510.redhat.com>
References: <patchbomb.1320306168@localhost6.localdomain6>
 <f3831c1617c86a51d875.1320306173@localhost6.localdomain6>
 <20120701092051.GA4515@redhat.com>
 <87d34fx990.fsf@rustcorp.com.au>
 <20120702072558.GA8268@redhat.com>
 <20120702160814.GB1750@t510.redhat.com>
 <87vci5wtzh.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vci5wtzh.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 10:17:46AM +0930, Rusty Russell wrote:
> On Mon, 2 Jul 2012 13:08:19 -0300, Rafael Aquini <aquini@redhat.com> wrote:
> > As 'locking in balloon', may I assume the approach I took for the compaction case
> > is OK and aligned to address these concerns of yours? If not, do not hesitate in
> > giving me your thoughts, please. I'm respinning a V3 series to address a couple
> > of extra nitpicks from the compaction standpoint, and I'd love to be able to
> > address any extra concern you might have on the balloon side of that work.
> 
> It's orthogonal, though looks like they clash textually :(
> 
> I'll re-spin MST's patch on top of yours, and include both in my tree,
> otherwise linux-next will have to do the merge.  But I'll await your
> push before pushing to Linus next merge window.
>
Thanks, Rusty.

I'll post V3 series quite soon.

Cheers!
Rafael
 
> Thanks,
> Rusty.
