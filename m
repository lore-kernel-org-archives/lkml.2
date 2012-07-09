Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751991Ab2GIAjz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 20:39:55 -0400
Received: from ozlabs.org ([203.10.76.45]:49875 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751429Ab2GIAjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 20:39:47 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org
Cc: levinsasha928@gmail.com, "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH] virtio-blk: add back VIRTIO_BLK_F_FLUSH
In-Reply-To: <1341482902-13318-1-git-send-email-pbonzini@redhat.com>
References: <1341482902-13318-1-git-send-email-pbonzini@redhat.com>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 09 Jul 2012 09:41:50 +0930
Message-ID: <87k3yd3i9l.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  5 Jul 2012 12:08:22 +0200, Paolo Bonzini <pbonzini@redhat.com> wrote:
> The old name is part of the userspace API, add it back for compatibility.
> 
> Reported-by: Sasha Levin <levinsasha928@gmail.com>
> Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
> ---
>  include/linux/virtio_blk.h |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/virtio_blk.h b/include/linux/virtio_blk.h
> index 18a1027..83a3116 100644
> --- a/include/linux/virtio_blk.h
> +++ b/include/linux/virtio_blk.h
> @@ -41,6 +41,9 @@
>  #define VIRTIO_BLK_F_TOPOLOGY	10	/* Topology information is available */
>  #define VIRTIO_BLK_F_CONFIG_WCE	11	/* Writeback mode available in config */
>  
> +/* Backwards-compatibility #defines for renamed features.  */
> +#define VIRTIO_BLK_F_FLUSH	VIRTIO_BLK_F_WCE

Please #ifndef __KERNEL__?

Thanks,
Rusty.
