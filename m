Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752092Ab2LJX6t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 18:58:49 -0500
Received: from ozlabs.org ([203.10.76.45]:36733 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750826Ab2LJX6r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 18:58:47 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>, David Miller <davem@davemloft.net>,
        netdev@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the virtio tree
In-Reply-To: <20121210133725.cb4a76545691b099c73c40ea@canb.auug.org.au>
References: <20121210133725.cb4a76545691b099c73c40ea@canb.auug.org.au>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Tue, 11 Dec 2012 09:11:46 +1030
Message-ID: <874njtedhx.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Rusty,
>
> After merging the virtio tree, today's linux-next build (x86_64
> allmodconfig) failed like this:
>
> drivers/net/virtio_net.c: In function 'vq2txq':
> drivers/net/virtio_net.c:150:2: error: implicit declaration of function 'virtqueue_get_queue_index' [-Werror=implicit-function-declaration]
>
> Caused by commit 986a4f4d452d ("virtio_net: multiqueue support") from the
> net-next tree interacting with commit 105e892960e1 ("virtio: move
> queue_index and num_free fields into core struct virtqueue") from the
> virtio tree.
>
> I applied the patch below and can carry it as necessary.

Thanks for this, your fix is correct.

Cheers,
Rusty.
