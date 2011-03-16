Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751237Ab1CPXz4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 19:55:56 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:12996 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995Ab1CPXzu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 19:55:50 -0400
Date: Thu, 17 Mar 2011 00:55:33 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Michal Hocko <mhocko@suse.cz>
cc: Jiri Kosina <trivial@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Documentation/vm/unevictable-lru.txt: CONFIG_UNEVICTABLE_LRU
 doesn't exist anymore
In-Reply-To: <20110316140137.GA12544@tiehlicka.suse.cz>
Message-ID: <alpine.LNX.2.00.1103170051510.24706@swampdragon.chaosbits.net>
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
> 

Reviewed-by: Jesper Juhl <jj@chaosbits.net>


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

