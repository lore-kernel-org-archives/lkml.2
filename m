Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab0I2RdP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 13:33:15 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35873 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753802Ab0I2RdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 13:33:14 -0400
Subject: Re: [PATCH] oprofile, arm: proper release resources on failure
From: Will Deacon <will.deacon@arm.com>
To: Robert Richter <robert.richter@amd.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20100929165958.GQ13563@erda.amd.com>
References: <20100929145225.GJ13563@erda.amd.com>
	 <1285774784.30080.19.camel@e102144-lin.cambridge.arm.com>
	 <20100929165027.GP13563@erda.amd.com> <20100929165958.GQ13563@erda.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Sep 2010 18:32:58 +0100
Message-ID: <1285781578.22669.4.camel@e102144-lin.cambridge.arm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 29 Sep 2010 17:33:01.0314 (UTC) FILETIME=[5D5FAE20:01CB5FFC]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert,

On Wed, 2010-09-29 at 17:59 +0100, Robert Richter wrote:
> On 29.09.10 18:50:27, Robert Richter wrote:
> 
> > > Hmm, these three hunks conflict with the patches I posted last
> > > month to fix the resource allocation and freeing. Can't we
> > > merge those patches instead? I have versions against -rc6 here:
> >
> > Yes, these patches are also in my oprofile/core branch and its changes
> > conflict, but are scheduled for the next merge window. This fix is for
> > urgent and for 2.6.36. We will then merge back rc7 or 2.6.36 to
> > oprofile/core and solve the conflicts. But if you don't have something
> > else for -rc7/.36 that conflicts, this should be ok.
> 
> So, it would be ok then to test only this fix on -rc6 without your
> other patches.
> 

Gotcha - this is a minimal fixup for -stable which we'll tackle properly
in the merge window with the stuff in oprofile/core. In that case I'm
happy for this to go upstream now:

Acked-by: Will Deacon <will.deacon@arm.com>


I also built an -rc6 kernel with this change on top and OProfile worked
happily across module loads/unloads.

As for oprofile/core; will you handle the conflicts there or do I need
to resend my previous patches?

Cheers,

Will

