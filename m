Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757182Ab0EKHJz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 03:09:55 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:60387 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757023Ab0EKHJy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 03:09:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=XYaQdSa7uLQCLd4MO++OFID92T0AmILOFFGwgi3UvB7T7BzO0Fqu1LrA+gbva2hx+m
         x0Z2/euzFKK2E+e1ajbzOU2G94lvsXwinVJlFNh0YsUl7qBMDaKcTG3XXwgskV/L7lQS
         onL1x+aqQTKdzB5HyA/QkzNKWiisl5R2rDIhk=
MIME-Version: 1.0
In-Reply-To: <1273561606.30322.17.camel@minggr.sh.intel.com>
References: <20100510152708.GS5104@lenovo>
	 <1273558879.30322.8.camel@minggr.sh.intel.com>
	 <20100511063047.GA24365@elte.hu> <20100511064144.GA29063@elte.hu>
	 <1273560424.30322.13.camel@minggr.sh.intel.com>
	 <1273561606.30322.17.camel@minggr.sh.intel.com>
Date: Tue, 11 May 2010 11:09:53 +0400
Message-ID: <AANLkTim2xXcwNaR5x88puYgW7UnIBfhlLq1HaIvyUrl0@mail.gmail.com>
Subject: Re: [rfc] x86,perf: P4 PMU -- use hash for p4_get_escr_idx
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>,
       Steven Rostedt <rostedt@goodmis.org>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 11, 2010, Lin Ming <ming.m.lin@intel.com> wrote:
> On Tue, 2010-05-11 at 14:47 +0800, Lin Ming wrote:
>> On Tue, 2010-05-11 at 14:41 +0800, Ingo Molnar wrote:
>> > * Ingo Molnar <mingo@elte.hu> wrote:
>> >
>> > >
>> > > * Lin Ming <ming.m.lin@intel.com> wrote:
>> > >
>> > > > On Mon, 2010-05-10 at 23:27 +0800, Cyrill Gorcunov wrote:
>> > > > > Hi Ming,
>> > > > >
>> > > > > could you give this patch a shot if possible? Compile
>> > > > > tested only. I would appreciate review and complains
>> > > > > as well :) I know you're busy with other perf task
>> > > > > so there is no hurry. Just to share the patch as early
>> > > > > as possible.
>> > > >
>> > > > Hi,
>> > > >
>> > > > I'm going to test this patch, but current tip/master(c6661c5) seems has
>> > > > problem.
>> > >
>> > > Does reverting 4fd38e4595e2f6c9d27732c042a0e16b2753049c help?
>> >
>> > If not then it would be nice if you could try to do a bisection.
>>
>> Yes, it's the commit 4fd38e45 causes the regression.
>
> Cyrill,
>
> After reverting commit 4fd38e45, this patch works well.
>
> Lin Ming
>
>
thanks a lot Ming, Ingo dont apply it yet, i will make it using warn
instead of bugon.
