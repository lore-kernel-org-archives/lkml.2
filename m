Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932576Ab1JXOZZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 10:25:25 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42066 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab1JXOZY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 10:25:24 -0400
Date: Mon, 24 Oct 2011 16:25:20 +0200
From: Grant Likely <grant.likely@secretlab.ca>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: robherring2@gmail.com, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] dt: Add empty of_match_node() macro
Message-ID: <20111024142520.GY8708@ponder.secretlab.ca>
References: <1319450012-13033-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319450012-13033-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 11:53:32AM +0200, Nicolas Ferre wrote:
> Add an empty macro for of_match_node() that will save
> some '#ifdef CONFIG_OF' for non-dt builds.
> 
> I have chosen to use a macro instead of a function to
> be able to avoid defining the first parameter.
> In fact, this "struct of_device_id *" first parameter
> is usualy not defined as well on non-dt builds.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>

After private discussion, yes this is okay.  I've picked it up.

g.

> ---
>  include/linux/of.h |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/include/linux/of.h b/include/linux/of.h
> index 736b747..92c40a1 100644
> --- a/include/linux/of.h
> +++ b/include/linux/of.h
> @@ -303,6 +303,7 @@ static inline struct device_node *of_parse_phandle(struct device_node *np,
>  }
>  
>  #define of_match_ptr(_ptr)	NULL
> +#define of_match_node(_matches, _node)	NULL
>  #endif /* CONFIG_OF */
>  
>  static inline int of_property_read_u32(const struct device_node *np,
> -- 
> 1.7.5.4
> 
