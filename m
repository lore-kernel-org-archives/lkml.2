Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab1KUTEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 14:04:07 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53201 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752660Ab1KUTED (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 14:04:03 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1111211358570.23676@cl320.eecs.utk.edu>
References: <alpine.DEB.2.00.1108031200390.703@cl320.eecs.utk.edu>
	<tip-ed13ec58bfe0d5dc95f748e6118432cb0fa283cb@git.kernel.org>
	<alpine.DEB.2.00.1111211321390.21667@cl320.eecs.utk.edu>
	<1321901536.28118.20.camel@twins>
	<alpine.DEB.2.00.1111211358570.23676@cl320.eecs.utk.edu>
Date: Mon, 21 Nov 2011 20:04:02 +0100
Message-ID: <CABPqkBRHW0ZmeqADptvBySLZpi6jc_bEFKoukkA6rtd5o04ziQ@mail.gmail.com>
Subject: Re: [tip:perf/urgent] perf/x86: Enable raw event access to Intel
 offcore events
From: Stephane Eranian <eranian@google.com>
To: Vince Weaver <vweaver1@eecs.utk.edu>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, mingo@redhat.com, hpa@zytor.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@elte.hu
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vince,

On Mon, Nov 21, 2011 at 8:01 PM, Vince Weaver <vweaver1@eecs.utk.edu> wrote:
> On Mon, 21 Nov 2011, Peter Zijlstra wrote:
>> On Mon, 2011-11-21 at 13:24 -0500, Vince Weaver wrote:
>
>> > Now I'll have to find something else
>> > to complain about, probably the scedulability issue introduced with the
>> > NMI watchdog.
>>
>> But you can disable that thing, right?
>>
>> echo 0 > /proc/sys/kernel/nmi_watchdog;
>>
>> or so should do the trick.
>
> yes, if the user running PAPI has root.
>
> That's unfortunately not always the case, and sometimes people want to
> have both the NMI watchdog operating and use PAPI simultaneously.
>

I don't understand why you have a problem with NMI watchdog. Multiplexing
allows you to still measure more events than there are counters.

> We have a workaround, but it currently disables kernel multiplexing and a
> few other nice features.
>
> Vince
> vweaver1@eecs.utk.edu
>
>
