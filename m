Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab1GVV7h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 17:59:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:37274 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab1GVV7f convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 17:59:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=NwnoHtVmp8wxpo36jUmA5XmyyDl2HBKrbWCFBFvSEAfowxyz/beS5P//JU32LaB70
	pw3JMucVdRr75CGQxBKIQ==
MIME-Version: 1.0
In-Reply-To: <20110722214305.GU8006@one.firstfloor.org>
References: <1309766525-14089-1-git-send-email-ming.m.lin@intel.com>
	<CABPqkBTznHwX_i=sraOkAkyAdX48fi3zVMa_M+Wdp09WMkQeoQ@mail.gmail.com>
	<20110722210114.GT8006@one.firstfloor.org>
	<CABPqkBQP7VNZBFj2h_TA67rr_QL7oxj1p8CjzG+faBd2m0dQig@mail.gmail.com>
	<20110722214305.GU8006@one.firstfloor.org>
Date: Fri, 22 Jul 2011 14:59:31 -0700
Message-ID: <CABPqkBRxkX9aJNcqM0OfmPTfvTEddmtNVxZHNWNGE0pQQkF75A@mail.gmail.com>
Subject: Re: [PATCH 0/4] perf: memory load/store events generalization
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Lin Ming <ming.m.lin@intel.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, Jul 22, 2011 at 2:43 PM, Andi Kleen <andi@firstfloor.org> wrote:
> On Fri, Jul 22, 2011 at 02:14:26PM -0700, Stephane Eranian wrote:
>> On Fri, Jul 22, 2011 at 2:01 PM, Andi Kleen <andi@firstfloor.org> wrote:
>> >> That looks okay as a first approach tool. But what people are most
>> >> often interested in is to see where the misses occur, i.e., you need
>> >> to display load/store addresses somehow, especially for the more
>> >
>> > But that's what it already does?  (for loads, stores
>> > are not in there yet) Did you try it?
>> >
>> I meant displaying the load + data addresses.
>
> That's what it does already.
>
Are you talking about dump_load_data()?

You get:
   - load instruction addr
   - load data address
   - latency
   - data source

How do you display the load instruction address? Just using plain perf report?
How do you display the load data addresses?

But what's certainly more interesting if to get an output that shows
the correlation between the load and data addresses.


> Or did you mean the instructions that caused them?
>
yes.

> -Andi
> --
> ak@linux.intel.com -- Speaking for myself only.
>
