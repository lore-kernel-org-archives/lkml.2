Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752394Ab2HMPgf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 11:36:35 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:36300 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751718Ab2HMPgd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 11:36:33 -0400
MIME-Version: 1.0
In-Reply-To: <1344871976.31459.35.camel@twins>
References: <CABPqkBRWLcP_9WOL_VvucnY7A2AcpzuvsUt4_ZUgYMREo-65dA@mail.gmail.com>
	<50235ED0.5010107@intel.com>
	<CABPqkBT-pvmhyOHfMXs7dXsJXpEVmaSST1xFFHzCu4CDBf7baw@mail.gmail.com>
	<1344535707.20277.20.camel@twins>
	<CABPqkBRzyrmL_yiKnYWU4qaSZXbD=JJVnm5py4PUcgAYvT=hcA@mail.gmail.com>
	<1344853682.31459.20.camel@twins>
	<CABPqkBREO7GE8qYqVoeyfFyC+gdn+TOf8f9sp_Yu0_O1Eds55A@mail.gmail.com>
	<1344871976.31459.35.camel@twins>
Date: Mon, 13 Aug 2012 17:36:31 +0200
Message-ID: <CABPqkBTSb_Q7cgBhKp97fM+6PAVM49o0-Ww4TzJjPn4FbYVAtA@mail.gmail.com>
Subject: Re: [BUG] perf: sharing of cpuctx between core and ibs PMU causes problems
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Yan, Zheng" <zheng.z.yan@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Robert Richter <robert.richter@amd.com>, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 13, 2012 at 5:32 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-08-13 at 14:53 +0200, Stephane Eranian wrote:
>>
>> Your proposal solves the problem, though it is not that pretty because
>> you're exposing
>> IBS stuff in sched.h aside for the 2 new iterations. But I don't see
>> another way around
>> this at this point.
>
> Yeah, I don't particularly like it either.. but I'm having a similar
> problem of not seeing anything better.
>
> I was going to see if I could make the two IBS PMUs share something, but
> that's going to be pain whichever way you turn it.

Let's use your patch then.

Acked-by: Stephane Eranian <eranian@google.com>
