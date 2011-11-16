Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab1KPKGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 05:06:52 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:55244 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755299Ab1KPKGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 05:06:50 -0500
MIME-Version: 1.0
In-Reply-To: <1321309008.1421.50.camel@twins>
References: <20111107110149.GA5177@quad>
	<20111110180308.GD15738@erda.amd.com>
	<CABPqkBSyYjM7V8cy--WRBHJ8o9TU9WUD9mGE1E5HntYdm2BHyw@mail.gmail.com>
	<1321279937.1421.18.camel@twins>
	<CABPqkBSc-o+ysZEVx72acE7+AY8fLR8sqFDedKBwh8H60Z77cQ@mail.gmail.com>
	<1321286406.1421.30.camel@twins>
	<CABPqkBTJU5PWpLq3en3sECiAK2AvgLoR+AVqRoZmfNpp_bM_Ug@mail.gmail.com>
	<1321309008.1421.50.camel@twins>
Date: Wed, 16 Nov 2011 11:06:49 +0100
Message-ID: <CABPqkBSAkeAtswCWHW_ytK9jPf_=P3xYb31PMCrHjxW+eQihYw@mail.gmail.com>
Subject: Re: [PATCH] perf_events: fix and improve x86 event scheduling
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        "ming.m.lin@intel.com" <ming.m.lin@intel.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 14, 2011 at 11:16 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2011-11-14 at 22:43 +0100, Peter Zijlstra wrote:
>>
>> Also, we don't need an exhaustive max flow solution, any flow that's
>> high enough to fit the required capacity will do, this too could
>> possibly be used to lower the (average) complexity bound.
>
> I think that for the typically very dense graphs this in particular
> could be very helpful in keeping the actual runtime low. For a fully
> connected e*c it really doesn't matter how you program things, all flows
> will have the same max and iterating them all is just wasting time.
>
> We just need to figure out which of the many different algorithms are
> best on average for our particular constraint sets.
>
I agree, I think there are optimization opportunities.
