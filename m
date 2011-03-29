Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169Ab1C2Xoa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 19:44:30 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59727 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab1C2Xo3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 19:44:29 -0400
Date: Tue, 29 Mar 2011 20:44:22 -0300
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Matthew Garrett <mjg@redhat.com>,
        Herton Ronaldo Krzesinski <herton@canonical.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 20/23] topstar-laptop: Convert remaining printk to
 pr_info
Message-ID: <20110329234421.GC1910@herton-IdeaPad-Y430>
References: <cover.1301436234.git.joe@perches.com>
 <a96da1fe175d7dc123f12433e30df14c60a67ce2.1301436234.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a96da1fe175d7dc123f12433e30df14c60a67ce2.1301436234.git.joe@perches.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 29, 2011 at 03:21:51PM -0700, Joe Perches wrote:
> To be similar to all other uses.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/platform/x86/topstar-laptop.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/platform/x86/topstar-laptop.c b/drivers/platform/x86/topstar-laptop.c
> index 1d07d6d..4c20447 100644
> --- a/drivers/platform/x86/topstar-laptop.c
> +++ b/drivers/platform/x86/topstar-laptop.c
> @@ -194,7 +194,7 @@ static int __init topstar_laptop_init(void)
>  	if (ret < 0)
>  		return ret;
>  
> -	printk(KERN_INFO "Topstar Laptop ACPI extras driver loaded\n");
> +	pr_info("ACPI extras driver loaded\n");
>  
>  	return 0;
>  }
> -- 
> 1.7.4.2.g597a6.dirty
> 

Acked-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>

-- 
[]'s
Herton
