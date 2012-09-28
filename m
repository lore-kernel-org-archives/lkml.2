Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049Ab2I1I5M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 04:57:12 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59469 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab2I1I5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 04:57:10 -0400
MIME-Version: 1.0
In-Reply-To: <1348822473.3292.55.camel@twins>
References: <1348806696-31170-1-git-send-email-andi@firstfloor.org>
	<1348806696-31170-9-git-send-email-andi@firstfloor.org>
	<1348822473.3292.55.camel@twins>
Date: Fri, 28 Sep 2012 10:57:08 +0200
Message-ID: <CABPqkBSnmeP1HoWiR80-yPuTvKLgtH+NcTM5WgjkXDmiUGhtwQ@mail.gmail.com>
Subject: Re: [PATCH 08/31] perf, x86: Report PEBS event in a raw format
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        x86 <x86@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 10:54 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Thu, 2012-09-27 at 21:31 -0700, Andi Kleen wrote:
>> Left over are the general registers. We need them for some analysis
>> too: for example for loop trip count and string instruction trip
>> count sampling.
>>
>> There isn't really any good way to generalize general registers.
>> Obviously they are different for every architecture.
>
> You missed the whole PERF_SAMPLE_REGS_USER stuff?

I will soon post a patchset to expose PEBS state. The patch set piggybacks
on the infrastructure used for USER_REGS and introduce a new sample_intr_regs
bitmask. That would be a more generic way of exposing the other fields
of the PEBS
record.
