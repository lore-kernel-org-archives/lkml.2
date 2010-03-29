Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab0C2WeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 18:34:20 -0400
Received: from cantor2.suse.de ([195.135.220.15]:47103 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754274Ab0C2WeR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 18:34:17 -0400
Date: Tue, 30 Mar 2010 00:34:15 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 13/17] hid: update gfp/slab.h includes
In-Reply-To: <1269885165-18617-14-git-send-email-tj@kernel.org>
Message-ID: <alpine.LNX.2.00.1003300033370.24576@pobox.suse.cz>
References: <1269885165-18617-1-git-send-email-tj@kernel.org> <1269885165-18617-14-git-send-email-tj@kernel.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Mar 2010, Tejun Heo wrote:

> Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> gfp.h or slab.h is included as necessary.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Jiri Kosina <jkosina@suse.cz>
> ---
>  drivers/hid/hid-roccat-kone.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
> index 2b1412e..7b11784 100644
> --- a/drivers/hid/hid-roccat-kone.c
> +++ b/drivers/hid/hid-roccat-kone.c
> @@ -35,6 +35,7 @@
>  #include <linux/hid.h>
>  #include <linux/usb.h>
>  #include <linux/module.h>
> +#include <linux/slab.h>
>  #include "hid-ids.h"
>  #include "hid-roccat-kone.h"

I have applied this to the branch of my tree in which development of 
roccat-kone driver for 2.6.35 is happening.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
