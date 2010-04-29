Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758628Ab0D3Rio (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:38:44 -0400
Received: from ozlabs.org ([203.10.76.45]:52366 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753030Ab0D3Rib (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:38:31 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: linux-next: manual merge of the rr tree with the net tree
Date: Thu, 29 Apr 2010 22:23:36 +0930
User-Agent: KMail/1.12.2 (Linux/2.6.31-20-generic; KDE/4.3.2; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, David Miller <davem@davemloft.net>,
       netdev@vger.kernel.org
References: <20100427115852.9f4cbb0f.sfr@canb.auug.org.au> <20100427040913.GA19951@redhat.com> <20100428155457.GB7467@redhat.com>
In-Reply-To: <20100428155457.GB7467@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004292223.36270.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Apr 2010 01:24:57 am Michael S. Tsirkin wrote:
> On Tue, Apr 27, 2010 at 07:09:13AM +0300, Michael S. Tsirkin wrote:
> > On Tue, Apr 27, 2010 at 11:58:52AM +1000, Stephen Rothwell wrote:
> > > Hi Rusty,
> > > 
> > > Today's linux-next merge of the rr tree got a conflict in
> > > drivers/net/virtio_net.c between commit
> > > 5e01d2f91df62be4d6f282149bc2a8858992ceca ("virtio-net: move sg off
> > > stack") from the net tree and commit
> > > 7f62a724a65f864d84f50857bbfd36c240155c8f ("virtio_net: use virtqueue_xxx
> > > wrappers") from the rr tree.
> > > 
> > > I fixed it up (see below) and can carry the fix as necessary.
> > 
> > Hmm, Rusty, do you intend for the patches to go through netdev this
> > time? If you do, it might be simplest to just ask Dave to merge
> > them in net-next-2.6 now. I can prepare and send them if you like.

Naah, they hit too many random virtio drivers.  It's pretty simple to keep
them separate, and once the new API is in place I'll send to Dave to merge.
It could take two cycles, but there's no huge rush.

Cheers,
Rusty.
