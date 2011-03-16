Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753422Ab1CPXiE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 19:38:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43658 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751661Ab1CPXiA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 19:38:00 -0400
Date: Thu, 17 Mar 2011 00:37:58 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Michal Hocko <mhocko@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation/vm/unevictable-lru.txt: CONFIG_UNEVICTABLE_LRU
 doesn't exist anymore
In-Reply-To: <20110316140137.GA12544@tiehlicka.suse.cz>
Message-ID: <alpine.LNX.2.00.1103170037280.19969@pobox.suse.cz>
References: <20110316140137.GA12544@tiehlicka.suse.cz>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Mar 2011, Michal Hocko wrote:

> commit 6837765963f1723e80ca97b1fae660f3a60d77df has removed the config
> option so we should sync up the doc as well.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  Documentation/vm/unevictable-lru.txt |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/vm/unevictable-lru.txt b/Documentation/vm/unevictable-lru.txt
> index 2d70d0d..aad6607 100644
> --- a/Documentation/vm/unevictable-lru.txt
> +++ b/Documentation/vm/unevictable-lru.txt
> @@ -84,8 +84,7 @@ indicate that the page is being managed on the unevictable list.
>  
>  The PG_unevictable flag is analogous to, and mutually exclusive with, the
>  PG_active flag in that it indicates on which LRU list a page resides when
> -PG_lru is set.  The unevictable list is compile-time configurable based on the
> -UNEVICTABLE_LRU Kconfig option.
> +PG_lru is set. 
>  
>  The Unevictable LRU infrastructure maintains unevictable pages on an additional
>  LRU list for a few reasons:

Thanks for spotting this. Modified changelog a little bit, stripped the 
trailing whitespace, and applied.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
