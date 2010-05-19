Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754206Ab0ESQ4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 12:56:42 -0400
Received: from soto.provo.novell.com ([137.65.250.214]:59136 "EHLO
	soto.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab0ESQ4l convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-ghaskins@novell.com:3:1>);
	Wed, 19 May 2010 12:56:41 -0400
Message-Id: <4BF3E0030200005A0006799D@soto.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 Beta 
Date: Wed, 19 May 2010 10:56:35 -0600
From: "Gregory Haskins" <ghaskins@novell.com>
To: "Stephen Rothwell" <sfr@canb.auug.org.au>
Cc: "Tejun Heo" <tj@kernel.org>, <linux-kernel@vger.kernel.org>,
       <linux-next@vger.kernel.org>
Subject: Re: [PATCH 06/17] vbus: update gfp/slab.h includes
References: <1269885165-18617-1-git-send-email-tj@kernel.org>
 <1269885165-18617-7-git-send-email-tj@kernel.org>
 <4BB2FF000200005A0006349E@soto.provo.novell.com>
 <20100520014225.e4343903.sfr@canb.auug.org.au>
In-Reply-To: <20100520014225.e4343903.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 5/19/2010 at 11:42 AM, in message
<20100520014225.e4343903.sfr@canb.auug.org.au>, Stephen Rothwell
<sfr@canb.auug.org.au> wrote: 
> Hi Gregory,
> 
> On Wed, 31 Mar 2010 05:51:28 -0600 "Gregory Haskins" <ghaskins@novell.com> 
> wrote:
>>
>> >>> On 3/29/2010 at 01:52 PM, in message
>> <1269885165-18617-7-git-send-email-tj@kernel.org>, Tejun Heo <tj@kernel.org>
>> wrote: 
>> > Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
>> > gfp.h or slab.h is included as necessary.
>> > 
>> > Signed-off-by: Tejun Heo <tj@kernel.org>
>> > Cc: Stephen Rothwell <sfr@canb.auug.org.au>
>> > Cc: Gregory Haskins <ghaskins@novell.com>
>> 
>> Thanks Tejun,
>> 
>> Acked-by: Gregory Haskins <ghaskins@novell.com>
>> 
>> (will add to my tree)
> 
> It never made it as far as I can see ... maybe something equivalent went in.

Hi Steven,

I dropped the ball on this.  Will merge when I return from lunch.

-Greg

> 
> From: Tejun Heo <tj@kernel.org>
> To: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
>         linux-kernel@vger.kernel.org
> Cc: Tejun Heo <tj@kernel.org>, Gregory Haskins <ghaskins@novell.com>
> Subject: [PATCH 06/17] vbus: update gfp/slab.h includes
> Date: Tue, 30 Mar 2010 02:52:34 +0900
> 
> Implicit slab.h inclusion via percpu.h is about to go away.  Make sure
> gfp.h or slab.h is included as necessary.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Gregory Haskins <ghaskins@novell.com>
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



