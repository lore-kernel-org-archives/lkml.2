Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab0C1Vxu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Mar 2010 17:53:50 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35570 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752844Ab0C1Vxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Mar 2010 17:53:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=fb88F84Ycf055njTJpPSP9e6EDOTAPoiSlqGI/r1Gw3txhvLVU9O0fEiGaHvr3RLd
	bSabteflg6CBzv7aH4NIA==
MIME-Version: 1.0
In-Reply-To: <87aattpi90.fsf@basil.nowhere.org>
References: <1269608924.12097.147.camel@laptop>
	 <87aattpi90.fsf@basil.nowhere.org>
Date: Sun, 28 Mar 2010 22:53:42 +0100
Message-ID: <bd4cb8901003281453u52378b6cr6d57186702271c54@mail.gmail.com>
Subject: Re: [PATCH] perf, x86: Add Nehelem PMU programming errata workaround
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 27, 2010 at 10:27 PM, Andi Kleen <andi@firstfloor.org> wrote:
> Peter Zijlstra <peterz@infradead.org> writes:
>
>> Subject: perf, x86: Add Nehelem PMU programming errata workaround
>> From: Peter Zijlstra <a.p.zijlstra@chello.nl>
>> Date: Fri Mar 26 13:59:41 CET 2010
>>
>> Implement the workaround for Intel Errata AAK100 and AAP53.
>>
>> Also, remove the Core-i7 name for Nehalem events since there are also
>> Westmere based i7 chips.
>
> Did you actually see this happen?
>
This is the same as AAJ91. At the time, I created a test program and it was
moderately easy to reproduce.

> It looks like this will make the context switch into a perf
> enabled process _MUCH_ more expensive, MSR writes are very slow.
>
Yes, but there is no alternative, I suspect.
