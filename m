Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757873Ab2DMIpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:45:53 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:51672 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755171Ab2DMIpv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:45:51 -0400
Date: Fri, 13 Apr 2012 09:45:44 +0100
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: zwu.kernel@gmail.com
Cc: linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH] virtio_ring: remove unused code in virtqueue_notify()
Message-ID: <20120413084544.GB15297@stefanha-thinkpad.localdomain>
References: <1334287563-8865-1-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334287563-8865-1-git-send-email-zwu.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12041308-5024-0000-0000-0000023F63AF
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 13, 2012 at 11:26:03AM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> ---
>  drivers/virtio/virtio_ring.c |    2 --
>  1 files changed, 0 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_ring.c b/drivers/virtio/virtio_ring.c
> index 5aa43c3..c6a54e6 100644
> --- a/drivers/virtio/virtio_ring.c
> +++ b/drivers/virtio/virtio_ring.c
> @@ -343,8 +343,6 @@ EXPORT_SYMBOL_GPL(virtqueue_kick_prepare);
>   */
>  void virtqueue_notify(struct virtqueue *_vq)
>  {
> -	struct vring_virtqueue *vq = to_vvq(_vq);
> -
>  	/* Prod other side to tell it about changes. */
>  	vq->notify(_vq);

vq->notify() uses 'vq'.  How does this work?

Stefan

