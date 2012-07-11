Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754912Ab2GKFOj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 01:14:39 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:48897 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab2GKFOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 01:14:38 -0400
MIME-Version: 1.0
In-Reply-To: <4FFCE2DC.1090201@gmail.com>
References: <CACV3sbK7jUCDZxGBs3RUYnQ4s+VyEt7VYeRKD50F07zZrYKgCg@mail.gmail.com>
	<4FFCE2DC.1090201@gmail.com>
Date: Wed, 11 Jul 2012 13:14:37 +0800
Message-ID: <CACV3sbLMOVm=WFofjc8-3pRvy1JduYVKWGY=EakjfhtftZPQ9A@mail.gmail.com>
Subject: Re: [PATCH] perf: fix perf-lock report coredump
From: Jovi Zhang <bookjovi@gmail.com>
To: David Ahern <dsahern@gmail.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 10:20 AM, David Ahern <dsahern@gmail.com> wrote:
> On 7/10/12 7:06 PM, Jovi Zhang wrote:
>>
>>  From 4b363bf16c12b76788fbace1475123b7214ae58d Mon Sep 17 00:00:00 2001
>> From: Jovi Zhang <bookjovi@gmail.com>
>> Date: Wed, 11 Jul 2012 16:53:57 +0800
>> Subject: [PATCH] perf: fix perf-lock report coredump
>>
>> Check sample type event raw_data is existed in perf.data firstly,
>> then invoke process_raw_event, otherwise it will coredump.
>
>
> Does this fix it for you:
> http://lkml.org/lkml/2012/7/6/405
>
Yeah, same problem.
But the question is if there have some sample event with raw data in
perf.data, are we still just exit(1)?
or let perf-lock only report those sample events with raw data?

> Also does 'perf lock record' work for you? If so can you send me your kernel
> config file?
Not working. I assume LOCKDEP is not configured in my test machine.

>
> Thanks,
>
> David
