Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031127Ab2CVV3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 17:29:25 -0400
Received: from ozlabs.org ([203.10.76.45]:60272 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1031055Ab2CVV3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 17:29:21 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Jason Wang <jasowang@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org,
        Christian Borntraeger <borntraeger@de.ibm.com>
Subject: Re: [PATCH] virtio-spec: clarify ro/rw bits and updating rule of virtio-net status field
In-Reply-To: <20120321063746.GA6773@redhat.com>
References: <20120320062020.12815.61342.stgit@jason-ThinkPad-T400> <87ty1jpm6p.fsf@rustcorp.com.au> <20120320224805.GA4997@redhat.com> <87ty1ializ.fsf@rustcorp.com.au> <20120321063746.GA6773@redhat.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Thu, 22 Mar 2012 15:00:22 +1030
Message-ID: <87aa399s0x.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Mar 2012 08:37:46 +0200, "Michael S. Tsirkin" <mst@redhat.com> wrote:
> Ah. Right, we need to trap for host to clear the bit.
> OK, so let's make the bit RO, and add
> VIRTIO_NET_CTRL_ANNOUNCED to acknowledge that we've
> seen VIRTIO_NET_S_ANNOUNCE using the control VQ?

Thanks, that's nice.  Guest should send arp packets first, then send
VIRTIO_NET_CTRL_ANNOUNCED, and ignore the bit being set in the meantime.

Thanks,
Rusty.
-- 
  How could I marry someone with more hair than me?  http://baldalex.org
