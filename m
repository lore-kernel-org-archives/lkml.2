Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754841Ab2DDHv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 03:51:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36169 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751546Ab2DDHvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 03:51:25 -0400
Date: Wed, 4 Apr 2012 10:51:37 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: David Miller <davem@davemloft.net>
Cc: jasowang@redhat.com, netdev@vger.kernel.org, qemu-devel@nongnu.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [V6 PATCH] virtio-net: send gratuitous packets when needed
Message-ID: <20120404075137.GB22658@redhat.com>
References: <20120328054428.34415.75432.stgit@amd-6168-8-1.englab.nay.redhat.com>
 <20120403.174905.769295608759578804.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120403.174905.769295608759578804.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 05:49:05PM -0400, David Miller wrote:
> From: Jason Wang <jasowang@redhat.com>
> Date: Wed, 28 Mar 2012 13:44:28 +0800
> 
> > As hypervior does not have the knowledge of guest network configuration, it's
> > better to ask guest to send gratuitous packets when needed.
> > 
> > Guest tests VIRTIO_NET_S_ANNOUNCE bit during config change interrupt and when it
> > is set, a workqueue is scheduled to send gratuitous packet through
> > NETDEV_NOTIFY_PEERS. This feature is negotiated through bit
> > VIRTIO_NET_F_GUEST_ANNOUNCE.
>  ...
> > Signed-off-by: Jason Wang <jasowang@redhat.com>
> 
> Michael and others, what's the story with this patch?

It's a new feature so it will be 3.5 material when it's ready.
Sent some comments for now.

Thanks,
MST


> _______________________________________________
> Virtualization mailing list
> Virtualization@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/virtualization
