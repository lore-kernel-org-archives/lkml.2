Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab1BPHYe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 02:24:34 -0500
Received: from ra.se.axis.com ([195.60.68.13]:58663 "EHLO ra.se.axis.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751281Ab1BPHYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 02:24:32 -0500
Date: Wed, 16 Feb 2011 08:24:24 +0100
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "trivial@kernel.org" <trivial@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH 1/3]arch:cris:arch-v10i:init.c Fix typo occationally to
	occasionally
Message-ID: <20110216072424.GZ13204@axis.com>
References: <1297839284-3091-1-git-send-email-justinmattock@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297839284-3091-1-git-send-email-justinmattock@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 07:54:44AM +0100, Justin P. Mattock wrote:
> The below patch fixes a typo occationally to occasionally.
> 
> Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

Acked-by: Jesper Nilsson <jesper.nilsson@axis.com>

> ---
>  arch/cris/arch-v10/mm/init.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/cris/arch-v10/mm/init.c b/arch/cris/arch-v10/mm/init.c
> index baa746c..e7f8066 100644
> --- a/arch/cris/arch-v10/mm/init.c
> +++ b/arch/cris/arch-v10/mm/init.c
> @@ -241,7 +241,7 @@ flush_etrax_cacherange(void *startadr, int length)
>  }
>  
>  /* Due to a bug in Etrax100(LX) all versions, receiving DMA buffers
> - * will occationally corrupt certain CPU writes if the DMA buffers
> + * will occasionally corrupt certain CPU writes if the DMA buffers
>   * happen to be hot in the cache.
>   * 
>   * As a workaround, we have to flush the relevant parts of the cache
> -- 
> 1.6.5.2.180.gc5b3e
/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
