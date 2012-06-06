Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757293Ab2FFQKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:10:46 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54790 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab2FFQKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:10:45 -0400
Date: Wed, 6 Jun 2012 18:10:44 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        eranian@google.com, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/5] perf, x86: Don't assume there can be only 4 PEBS events
Message-ID: <20120606161044.GH27374@one.firstfloor.org>
References: <1338944211-28275-1-git-send-email-andi@firstfloor.org> <1338944211-28275-2-git-send-email-andi@firstfloor.org> <1338994803.2749.132.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338994803.2749.132.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 05:00:03PM +0200, Peter Zijlstra wrote:
> On Tue, 2012-06-05 at 17:56 -0700, Andi Kleen wrote:
> > On Sandy Bridge in non HT mode there are 8 counters available. Since every
> > counter can write a PEBS record assuming there are 4 max is incorrect. Use
> > the reported counter number -- with an upper limit for a static array -- instead.
> 
> 
> While I queued this patch, its effectively a NOP since all SNB PEBS
> constraints are still on 4 counters.

Yes need to update the constraints too. I think Stephane was looking at that.
Perhaps two sets depending on the counters in CPUID?

FWIW I saw the warn on triggering.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
