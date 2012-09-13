Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758815Ab2IMUoa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Sep 2012 16:44:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419Ab2IMUo3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Sep 2012 16:44:29 -0400
Date: Thu, 13 Sep 2012 17:44:09 -0300
From: Rafael Aquini <aquini@redhat.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -mm] enable CONFIG_COMPACTION by default
Message-ID: <20120913204408.GA10671@optiplex.redhat.com>
References: <20120913162104.1458bea2@cuia.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120913162104.1458bea2@cuia.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 04:21:04PM -0400, Rik van Riel wrote:
> Now that lumpy reclaim has been removed, compaction is the
> only way left to free up contiguous memory areas. It is time
> to just enable CONFIG_COMPACTION by default.
>     
> Signed-off-by: Rik van Riel <riel@redhat.com>
> 
> diff --git a/mm/Kconfig b/mm/Kconfig
> index d5c8019..32ea0ef 100644
> --- a/mm/Kconfig
> +++ b/mm/Kconfig
> @@ -191,6 +191,7 @@ config SPLIT_PTLOCK_CPUS
>  # support for memory compaction
>  config COMPACTION
>  	bool "Allow for memory compaction"
> +	def_bool y
>  	select MIGRATION
>  	depends on MMU
>  	help
>

Acked-by: Rafael Aquini <aquini@redhat.com> 

