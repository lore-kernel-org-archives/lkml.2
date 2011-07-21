Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752791Ab1GUITy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 04:19:54 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42381 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1GUITv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 04:19:51 -0400
Date: Thu, 21 Jul 2011 10:19:46 +0200
From: Tejun Heo <tj@kernel.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: Boiler plate functions for ida / idr allocation?
Message-ID: <20110721081946.GB3455@htj.dyndns.org>
References: <4E1D6900.6040500@cam.ac.uk>
 <20110713133139.GO2872@htj.dyndns.org>
 <4E1DA232.30408@cam.ac.uk>
 <878vrs2if3.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <878vrs2if3.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 05:07:36PM +0930, Rusty Russell wrote:
> From: Rusty Russell <rusty@rustcorp.com.au>
> Subject: ida: Simplified functions for id allocation.
> 
> The current hyper-optimized functions are overkill if you simply want
> to allocate an id for a device.  Create versions which use an internal
> lock.
> 
> Thanks to Tejun for feedback.  Feel free to delete the #ifdef TEST
> code.
> 
> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
...
>  static struct kmem_cache *idr_layer_cache;
> +static DEFINE_SPINLOCK(simple_ida);

I think the name is a bit confusing.  Maybe simple_ida_lock is better?
Other than that,

 Acked-by: Tejun Heo <tj@kernel.org>

I guess this is best routed through -mm?

Thanks.

-- 
tejun
