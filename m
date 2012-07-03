Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933172Ab2GCEjJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 00:39:09 -0400
Received: from ozlabs.org ([203.10.76.45]:54866 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751089Ab2GCEjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 00:39:08 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Rafael Aquini <aquini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: RFD: virtio balloon API use (was Re: [PATCH 5 of 5] virtio: expose added descriptors immediately)
In-Reply-To: <20120702160814.GB1750@t510.redhat.com>
References: <patchbomb.1320306168@localhost6.localdomain6> <f3831c1617c86a51d875.1320306173@localhost6.localdomain6> <20120701092051.GA4515@redhat.com> <87d34fx990.fsf@rustcorp.com.au> <20120702072558.GA8268@redhat.com> <20120702160814.GB1750@t510.redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Tue, 03 Jul 2012 10:17:46 +0930
Message-ID: <87vci5wtzh.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jul 2012 13:08:19 -0300, Rafael Aquini <aquini@redhat.com> wrote:
> As 'locking in balloon', may I assume the approach I took for the compaction case
> is OK and aligned to address these concerns of yours? If not, do not hesitate in
> giving me your thoughts, please. I'm respinning a V3 series to address a couple
> of extra nitpicks from the compaction standpoint, and I'd love to be able to
> address any extra concern you might have on the balloon side of that work.

It's orthogonal, though looks like they clash textually :(

I'll re-spin MST's patch on top of yours, and include both in my tree,
otherwise linux-next will have to do the merge.  But I'll await your
push before pushing to Linus next merge window.

Thanks,
Rusty.
