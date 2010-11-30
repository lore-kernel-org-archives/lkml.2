Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab0K3EaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 23:30:08 -0500
Received: from bld-mail12.adl6.internode.on.net ([150.101.137.97]:51903 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751204Ab0K3EaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 23:30:07 -0500
Date: Tue, 30 Nov 2010 15:30:01 +1100
From: Dave Chinner <david@fromorbit.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] lib: percpu counter add unless less than
 functionality
Message-ID: <20101130043001.GC3556@dastard>
References: <1290991002-18680-1-git-send-email-david@fromorbit.com>
 <1290991002-18680-2-git-send-email-david@fromorbit.com>
 <1291032530.32004.26.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1291032530.32004.26.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 29, 2010 at 01:08:50PM +0100, Peter Zijlstra wrote:
> On Mon, 2010-11-29 at 11:36 +1100, Dave Chinner wrote:
> > +int percpu_counter_add_unless_lt(struct percpu_counter *fbc, s64 amount,
> > +                                                       s64 threshold);
> 
> It might make sense to implement that as;
> 
>   __percpu_counter_add_unless_lt(struct percpu_counter *fbc,
> 				 s64 amount,
> 				 s64 threshold,
> 				 s32 batch);
> 
> That way its consistent with the __percpu_counter_add() implementation
> where you can also specify the batch value.

Good point. I'll fix that up.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
