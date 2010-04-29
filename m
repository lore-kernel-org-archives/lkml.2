Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758100Ab0D3Q5Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:57:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50812 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758052Ab0D3QzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:55:20 -0400
Date: Thu, 29 Apr 2010 17:06:44 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org
Subject: Re: linux-next: manual merge of the rr tree with the net tree
Message-ID: <20100429140644.GA26393@redhat.com>
References: <20100427115852.9f4cbb0f.sfr@canb.auug.org.au> <20100427040913.GA19951@redhat.com> <20100428155457.GB7467@redhat.com> <201004292223.36270.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201004292223.36270.rusty@rustcorp.com.au>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 29, 2010 at 10:23:36PM +0930, Rusty Russell wrote:
> On Thu, 29 Apr 2010 01:24:57 am Michael S. Tsirkin wrote:
> > On Tue, Apr 27, 2010 at 07:09:13AM +0300, Michael S. Tsirkin wrote:
> > > On Tue, Apr 27, 2010 at 11:58:52AM +1000, Stephen Rothwell wrote:
> > > > Hi Rusty,
> > > > 
> > > > Today's linux-next merge of the rr tree got a conflict in
> > > > drivers/net/virtio_net.c between commit
> > > > 5e01d2f91df62be4d6f282149bc2a8858992ceca ("virtio-net: move sg off
> > > > stack") from the net tree and commit
> > > > 7f62a724a65f864d84f50857bbfd36c240155c8f ("virtio_net: use virtqueue_xxx
> > > > wrappers") from the rr tree.
> > > > 
> > > > I fixed it up (see below) and can carry the fix as necessary.
> > > 
> > > Hmm, Rusty, do you intend for the patches to go through netdev this
> > > time? If you do, it might be simplest to just ask Dave to merge
> > > them in net-next-2.6 now. I can prepare and send them if you like.
> 
> Naah, they hit too many random virtio drivers.  It's pretty simple to keep
> them separate, and once the new API is in place I'll send to Dave to merge.
> It could take two cycles, but there's no huge rush.
> 
> Cheers,
> Rusty.

Well, I'm just thinking of a way to make working on virtio-net less painful.
Maybe you could just put a copy of the two patches above on your tree?

-- 
MST
