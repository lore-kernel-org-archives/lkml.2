Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987Ab2HOW6b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 18:58:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39750 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751765Ab2HOW63 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 18:58:29 -0400
MIME-Version: 1.0
In-Reply-To: <1345042516.31459.99.camel@twins>
References: <5028F12C.7080405@intel.com>
	<CADZ9YHhB_1ZeZM3WOFiz0kcx1ZR9iFO_R=Mst_w=QKXOi4Z9OQ@mail.gmail.com>
	<1345042516.31459.99.camel@twins>
Date: Thu, 16 Aug 2012 04:58:29 +0600
Message-ID: <CADZ9YHjLzNtR+EVQYbutV034T8zrPr52D6mMGLQL3VgaxnemAw@mail.gmail.com>
Subject: Re: [discussion]sched: a rough proposal to enable power saving in scheduler
From: Rakib Mullick <rakib.mullick@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Alex Shi <alex.shi@intel.com>, Suresh Siddha <suresh.b.siddha@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, vincent.guittot@linaro.org,
        svaidy@linux.vnet.ibm.com, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 8:55 PM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Wed, 2012-08-15 at 20:24 +0600, Rakib Mullick wrote:
>> How do you plan to test this power saving scheme? Using powertop? Or,
>> is there any other tools?
>
> We should start out simple enough that we can validate it by looking at
> task placement by hand, eg. 4 tasks on a dual socket quad-core, should
> only keep one socket awake.
>
Yeah, that's what we can do "task placement", that's what scheduler is
known for :).

> We can also add an power aware evaluator to Linsched (another one of
> those things that needs getting sorted).
>
> And yeah, someone running with a power meter is of course king.
>
> _BUT_ we shouldn't go off the wall with power meters as that very
> quickly gets very specific to the system being measured.
>
> We should really keep this thing as simple as possible while still
> providing some benefit for all various architectures without tons of per
> arch knobs and knowhow.

Perhaps this is because, there's no well sorted specification from
various arch, to properly deal with power saving from scheduler's POV.
Actually, this is what I wasn't really sure whether there's any
documentation of how scheduler should work to save power.

Thanks,
Rakib
