Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793Ab2LCK6W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 05:58:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754705Ab2LCK6T (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 05:58:19 -0500
Date: Mon, 3 Dec 2012 13:01:06 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Cong Ding <dinggnu@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tools:virtio: fix compilation warning
Message-ID: <20121203110106.GB26167@redhat.com>
References: <1354530294-10178-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354530294-10178-1-git-send-email-dinggnu@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 10:24:54AM +0000, Cong Ding wrote:
> We do not allow old-style function definition.  Always spell foo(void) if
> a function does not take any parameters.
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>

Thanks, applied.

> ---
>  tools/virtio/virtio_test.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/tools/virtio/virtio_test.c b/tools/virtio/virtio_test.c
> index e626fa5..6d25dcd 100644
> --- a/tools/virtio/virtio_test.c
> +++ b/tools/virtio/virtio_test.c
> @@ -232,7 +232,7 @@ const struct option longopts[] = {
>  	}
>  };
>  
> -static void help()
> +static void help(void)
>  {
>  	fprintf(stderr, "Usage: virtio_test [--help]"
>  		" [--no-indirect]"
> -- 
> 1.7.4.5
