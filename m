Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508Ab1GKSrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 14:47:00 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34849 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758337Ab1GKSq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 14:46:58 -0400
Date: Mon, 11 Jul 2011 14:35:42 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Joe Perches <joe@perches.com>
Cc: Stanislaw Gruszka <sgruszka@redhat.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] iwlegacy: Add missing comma between constant string
 array
Message-ID: <20110711183542.GB2650@tuxdriver.com>
References: <cover.1310187270.git.joe@perches.com>
 <36f8b5d1a32b8702941ebeda7a406188af132e9e.1310187270.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <36f8b5d1a32b8702941ebeda7a406188af132e9e.1310187270.git.joe@perches.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

How is this array indexed?  Aren't you changing the index of the
later strings?

On Fri, Jul 08, 2011 at 11:20:24PM -0700, Joe Perches wrote:
> Multiple quoted strings are concatenated without comma separators.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/wireless/iwlegacy/iwl4965-base.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlegacy/iwl4965-base.c b/drivers/net/wireless/iwlegacy/iwl4965-base.c
> index 46242d2..1433466 100644
> --- a/drivers/net/wireless/iwlegacy/iwl4965-base.c
> +++ b/drivers/net/wireless/iwlegacy/iwl4965-base.c
> @@ -1484,7 +1484,7 @@ static const char * const desc_lookup_text[] = {
>  	"NMI_INTERRUPT_DATA_ACTION_PT",
>  	"NMI_TRM_HW_ER",
>  	"NMI_INTERRUPT_TRM",
> -	"NMI_INTERRUPT_BREAK_POINT"
> +	"NMI_INTERRUPT_BREAK_POINT",
>  	"DEBUG_0",
>  	"DEBUG_1",
>  	"DEBUG_2",
> -- 
> 1.7.6.131.g99019
> 
> 

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
