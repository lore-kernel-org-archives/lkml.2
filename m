Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756884Ab2GLDtw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 23:49:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43413 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751156Ab2GLDtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 23:49:51 -0400
Message-ID: <4FFE495A.9070101@gmail.com>
Date: Wed, 11 Jul 2012 21:49:46 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Jovi Zhang <bookjovi@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] perf: fix perf-lock report coredump
References: <CACV3sbK7jUCDZxGBs3RUYnQ4s+VyEt7VYeRKD50F07zZrYKgCg@mail.gmail.com> <4FFCE2DC.1090201@gmail.com> <CACV3sbLMOVm=WFofjc8-3pRvy1JduYVKWGY=EakjfhtftZPQ9A@mail.gmail.com>
In-Reply-To: <CACV3sbLMOVm=WFofjc8-3pRvy1JduYVKWGY=EakjfhtftZPQ9A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/10/12 11:14 PM, Jovi Zhang wrote:
>> Does this fix it for you:
>> http://lkml.org/lkml/2012/7/6/405
>>
> Yeah, same problem.
> But the question is if there have some sample event with raw data in
> perf.data, are we still just exit(1)?
> or let perf-lock only report those sample events with raw data?

perf-lock uses 4 tracepoints. tracepoints add -R (raw data) to events. 
So, if the perf.data does not have tracepoints, there is no need for 
perf-lock info or report subcommands to proceed.

David
