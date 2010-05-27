Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620Ab0E0Uyw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:54:52 -0400
Received: from smtp-out.google.com ([74.125.121.35]:27201 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968Ab0E0Uyv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:54:51 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=OYoE4hoGNsn/uGRIGJGlkngFl/AilOXz1LKLoik/n/FWJ8aTuOhuSTz5WNBMcIBrM
	0cLs5kjR1gLUd+dgRRIpQ==
MIME-Version: 1.0
In-Reply-To: <20100527184135.GL9874@ghostprotocols.net>
References: <20100503203813.GA17886@sharma-home.net>
	<1272919356.1642.154.camel@laptop>
	<w2u850c51c31005031353x9be8ca7h90c244d64675ce3e@mail.gmail.com>
	<1272964598.5605.133.camel@twins>
	<20100505181612.GA5091@sharma-home.net>
	<20100527184135.GL9874@ghostprotocols.net>
Date: Thu, 27 May 2010 13:54:46 -0700
Message-ID: <AANLkTim4UdMxxPkhHjVd_433Uk2QoVXBTy44KUlRBNSX@mail.gmail.com>
Subject: Re: [PATCH] perf: implement recording/reporting per-cpu samples
From: Arun Sharma <aruns@google.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@elte.hu, paulus@samba.org, davem@davemloft.net,
       fweisbec@gmail.com
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 11:41 AM, Arnaldo Carvalho de Melo
<acme@ghostprotocols.net> wrote:
> Em Wed, May 05, 2010 at 11:16:12AM -0700, Arun Sharma escreveu:
>> On Tue, May 04, 2010 at 11:16:38AM +0200, Peter Zijlstra wrote:
>> > > In a shared multi-core environment, users want to analyze why their
>> > > program was slow. In particular, if the code ran slower only on
>> > > certain CPUs due to interference from other programs or kernel
>> > > threads, they want to know that.
>> >
>> > But for that you use perf record -a, right? So you record all cpus
>> > allways -- otherwise there is no telling what was happening to make it
>> > go slow.
>>
>> The updated patch records the CPU only in the system_wide mode.
>
> I think this should be done only if you'll actually need it, as in,
> "cpu" is one of the sort keys, but that can be done as a followup patch,
> but there is another thing I think you need to change, see below.
>

How would you know if the user is going to sort by cpu at "perf record" time?

Thanks for taking care of the second part.

 -Arun
