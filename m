Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755404Ab1KCLIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 07:08:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17434 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752698Ab1KCLIk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 07:08:40 -0400
Date: Thu, 3 Nov 2011 13:09:55 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-balloon: Trivial cleanups
Message-ID: <20111103110954.GC18296@redhat.com>
References: <1320308404-28859-1-git-send-email-levinsasha928@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320308404-28859-1-git-send-email-levinsasha928@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 03, 2011 at 10:20:04AM +0200, Sasha Levin wrote:
> Trivial changes to remove forgotten junk, format comments, and correct names.
> 
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

3.3 material.
Rusty, you want to take it? Want me to?

> ---
>  drivers/virtio/virtio_balloon.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
> index e058ace..289e998 100644
> --- a/drivers/virtio/virtio_balloon.c
> +++ b/drivers/virtio/virtio_balloon.c
> @@ -1,4 +1,5 @@
> -/* Virtio balloon implementation, inspired by Dor Loar and Marcelo
> +/*
> + * Virtio balloon implementation, inspired by Dor Laor and Marcelo
>   * Tosatti's implementations.
>   *
>   *  Copyright 2008 Rusty Russell IBM Corporation
> @@ -17,7 +18,7 @@
>   *  along with this program; if not, write to the Free Software
>   *  Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
>   */
> -//#define DEBUG
> +
>  #include <linux/virtio.h>
>  #include <linux/virtio_balloon.h>
>  #include <linux/swap.h>
> @@ -148,7 +149,6 @@ static void leak_balloon(struct virtio_balloon *vb, size_t num)
>  		vb->num_pages--;
>  	}
>  
> -
>  	/*
>  	 * Note that if
>  	 * virtio_has_feature(vdev, VIRTIO_BALLOON_F_MUST_TELL_HOST);
> -- 
> 1.7.7.1
