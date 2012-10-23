Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933142Ab2JWNsG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:48:06 -0400
Received: from mga03.intel.com ([143.182.124.21]:65469 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933106Ab2JWNsF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:48:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,635,1344236400"; 
   d="scan'208";a="159362053"
Date: Tue, 23 Oct 2012 21:48:00 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: David Howells <dhowells@redhat.com>
Cc: dshadowwolf@gmail.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] UAPI: Fix tools/vm/page-types.c
Message-ID: <20121023134800.GA21587@localhost>
References: <20121023132007.32177.42349.stgit@warthog.procyon.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121023132007.32177.42349.stgit@warthog.procyon.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 02:20:07PM +0100, David Howells wrote:
> Fix tools/vm/page-types.c to use the UAPI variant of linux/kernel-page-flags.h
> lest the following error appear:
> 
> 	In file included from page-types.c:38:0:
> 	../../include/linux/kernel-page-flags.h:4:42: fatal error:
> 	uapi/linux/kernel-page-flags.h: No such file or directory
> 
> Reported-by: Daniel Hazelton <dshadowwolf@gmail.com>
> Signed-off-by: David Howells <dhowells@redhat.com>
> cc: Fengguang Wu <fengguang.wu@intel.com>

Looks like the right solution.

Reviewed-by: Fengguang Wu <fengguang.wu@intel.com>

> ---
> 
>  tools/vm/page-types.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/vm/page-types.c b/tools/vm/page-types.c
> index cd1b03e..b76edf2 100644
> --- a/tools/vm/page-types.c
> +++ b/tools/vm/page-types.c
> @@ -35,7 +35,7 @@
>  #include <sys/mount.h>
>  #include <sys/statfs.h>
>  #include "../../include/uapi/linux/magic.h"
> -#include "../../include/linux/kernel-page-flags.h"
> +#include "../../include/uapi/linux/kernel-page-flags.h"
>  
>  
>  #ifndef MAX_PATH
