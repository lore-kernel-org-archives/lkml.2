Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab0HPNOV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 09:14:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:44651 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752908Ab0HPNOU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 09:14:20 -0400
Date: Mon, 16 Aug 2010 15:14:14 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2]drivers/video/vesafb.c Fix a typo.
In-Reply-To: <1281804202-27500-1-git-send-email-justinmattock@gmail.com>
Message-ID: <alpine.LNX.2.00.1008161514050.1019@pobox.suse.cz>
References: <1281804202-27500-1-git-send-email-justinmattock@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Aug 2010, Justin P. Mattock wrote:

> ---
>  drivers/video/vesafb.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/video/vesafb.c b/drivers/video/vesafb.c
> index 090aa1a..6a069d0 100644
> --- a/drivers/video/vesafb.c
> +++ b/drivers/video/vesafb.c
> @@ -253,7 +253,7 @@ static int __init vesafb_probe(struct platform_device *dev)
>  	size_vmode = vesafb_defined.yres * vesafb_fix.line_length;
>  
>  	/*   size_total -- all video memory we have. Used for mtrr
> -	 *                 entries, ressource allocation and bounds
> +	 *                 entries, resource allocation and bounds
>  	 *                 checking. */
>  	size_total = screen_info.lfb_size * 65536;
>  	if (vram_total)

Applied, thanks.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
