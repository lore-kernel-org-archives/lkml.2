Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758580Ab2I1PhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 11:37:09 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38611 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758473Ab2I1PhH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 11:37:07 -0400
Date: Fri, 28 Sep 2012 17:37:06 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        x86@kernel.org, eranian@google.com, acme@redhat.com,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>
Subject: Re: [PATCH 04/31] perf, core: Add generic intx/intx_checkpointed counter modifiers
Message-ID: <20120928153706.GV16230@one.firstfloor.org>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org> <1348806696-31170-5-git-send-email-andi@firstfloor.org> <1348822920.3292.60.camel@twins> <20120928145324.GQ16230@one.firstfloor.org> <1348845807.3292.88.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348845807.3292.88.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 05:23:27PM +0200, Peter Zijlstra wrote:
> On Fri, 2012-09-28 at 16:53 +0200, Andi Kleen wrote:
> > 
> > Also as a selfish reason I would prefer something that is short 
> > to type. The qualifiers are quite common in scripts that do
> > measurements here. So I would prefer to keep :t and :c as user
> > interface.  But the internal implementation can be adjusted 
> > of course. 
> 
> But since its so very specific to HSW consuming such limited resources

We still have quite a few letters in the Latin alphabet :)

I assume any CPU with TSX will have something like that. PMU is model 
specific, but it's obviously something that is needed. So I wouldn't 
really call it HSW specific. Something like this will be likely
in many Intel CPUs going forward. 

Also I don't know for sure but it wouldn't surprise me if the other
CPUs with transactions (BG etc.) have something similar.

> 
> Maybe we can allow some configuration on the userspace side that would
> allow each individual user to be lazy and create shortcuts or aliasses
> of some sort ?

That would likely be a logistical nightmare. You could never send
a measurement script to someone else.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
