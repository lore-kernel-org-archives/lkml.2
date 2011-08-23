Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756289Ab1HWX3a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 19:29:30 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:39431 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755941Ab1HWX2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 19:28:12 -0400
X-Sasl-enc: nz3pd1np1t8NLGfKYRmH2PQ4lkliZgHffUJ/AzAURkrH 1314142091
Date: Tue, 23 Aug 2011 16:14:45 -0700
From: Greg KH <greg@kroah.com>
To: "K. Y. Srinivasan" <kys@microsoft.com>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        virtualization@lists.osdl.org, Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 1/8] Staging: hv: vmbus: Fix a checkpatch warning in
 ring_buffer.c
Message-ID: <20110823231445.GB9955@kroah.com>
References: <1311101018-23370-1-git-send-email-kys@microsoft.com>
 <1311101065-23417-1-git-send-email-kys@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311101065-23417-1-git-send-email-kys@microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 11:44:18AM -0700, K. Y. Srinivasan wrote:
> Fix a checkpatch warning in ring_buffer.c (line over 80 characters).
> 
> Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
> Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
> ---
>  drivers/staging/hv/ring_buffer.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/hv/ring_buffer.c b/drivers/staging/hv/ring_buffer.c
> index 9212699..e41d206 100644
> --- a/drivers/staging/hv/ring_buffer.c
> +++ b/drivers/staging/hv/ring_buffer.c
> @@ -34,7 +34,8 @@
>  
>  
>  /* Amount of space to write to */
> -#define BYTES_AVAIL_TO_WRITE(r, w, z) ((w) >= (r)) ? ((z) - ((w) - (r))) : ((r) - (w))
> +#define BYTES_AVAIL_TO_WRITE(r, w, z) \
> +(((w) >= (r)) ? ((z) - ((w) - (r))) : ((r) - (w)))

Please at least indent the second line a little bit, otherwise it's a
pain to read, right?

greg k-h
