Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab0CaMLv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 08:11:51 -0400
Received: from soto.provo.novell.com ([137.65.250.214]:43534 "EHLO
	soto.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757243Ab0CaMLt convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com:3:1>);
	Wed, 31 Mar 2010 08:11:49 -0400
X-Greylist: delayed 1213 seconds by postgrey-1.27 at vger.kernel.org; Wed, 31 Mar 2010 08:11:49 EDT
Message-Id: <4BB2FF000200005A0006349E@soto.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Wed, 31 Mar 2010 05:51:28 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: <sfr@canb.auug.org.au>, "Tejun Heo" <tj@kernel.org>,
       <linux-kernel@vger.kernel.org>, <linux-next@vger.kernel.org>
Subject: Re: [PATCH 06/17] vbus: update gfp/slab.h includes
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
 <1269885165-18617-7-git-send-email-tj@kernel.org>
In-Reply-To: <1269885165-18617-7-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 3/29/2010 at 01:52 PM, in message
<1269885165-18617-7-git-send-email-tj@kernel.org>, Tejun Heo <tj@kernel.org>
wrote: 
> Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> gfp.h or slab.h is included as necessary.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Gregory Haskins <ghaskins@novell.com>

Thanks Tejun,

Acked-by: Gregory Haskins <ghaskins@novell.com>

(will add to my tree)

> ---
>  drivers/vbus/pci-bridge.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/vbus/pci-bridge.c b/drivers/vbus/pci-bridge.c
> index 0d51324..36de7c4 100644
> --- a/drivers/vbus/pci-bridge.c
> +++ b/drivers/vbus/pci-bridge.c
> @@ -22,6 +22,7 @@
>  #include <linux/pci.h>
>  #include <linux/mm.h>
>  #include <linux/workqueue.h>
> +#include <linux/slab.h>
>  #include <linux/debugfs.h>
>  #include <linux/seq_file.h>
>  #include <linux/ioq.h



