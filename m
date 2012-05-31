Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932318Ab2EaIrf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:47:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15488 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757912Ab2EaIra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:47:30 -0400
Date: Thu, 31 May 2012 11:47:18 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Rusty Russell <rusty@rustcorp.com.au>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC] virtio-net: remove useless disable on freeze
Message-ID: <20120531084717.GB32310@redhat.com>
References: <20120404091954.GA3776@redhat.com>
 <20120528125325.GA22576@redhat.com>
 <87r4u2dllo.fsf@rustcorp.com.au>
 <20120531183508.f426eb25fe1b94139c637348@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120531183508.f426eb25fe1b94139c637348@canb.auug.org.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 06:35:08PM +1000, Stephen Rothwell wrote:
> Hi all,
> 
> On Wed, 30 May 2012 19:41:47 +0930 Rusty Russell <rusty@rustcorp.com.au> wrote:
> >
> > On Mon, 28 May 2012 15:53:25 +0300, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> > > On Wed, Apr 04, 2012 at 12:19:54PM +0300, Michael S. Tsirkin wrote:
> > > > disable_cb is just an optimization: it
> > > > can not guarantee that there are no callbacks.
> > > > 
> > > > I didn't yet figure out whether a callback
> > > > in freeze will trigger a bug, but disable_cb
> > > > won't address it in any case. So let's remove
> > > > the useless calls as a first step.
> > > > 
> > > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> > > 
> > > Looks like this isn't in the 3.5 pull request -
> > > just lost in the shuffle?
> > > disable_cb is advisory so can't be relied upon.
> > 
> > I always (try to?) reply as I accept patches.
> > 
> > This one did slip by, but it's harmless so no need to push AFAICT.
> > 
> > Applied.
> 
> This patch exists in two trees in linux-next already ... Davem's net tree
> (so presumably he will send it to Linus shortly) and Michael's vhost tree
> (is that tree needed any more?).

Yes and I dropped the patch from there, just did not push yet.

>  Presumably it is now also in the rr
> tree?
> 
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au


