Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758857Ab2D0P5O (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 11:57:14 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50483 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754305Ab2D0P5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 11:57:11 -0400
MIME-Version: 1.0
In-Reply-To: <1335540635.2463.134.camel@laptop>
References: <1333390758-10893-1-git-send-email-robert.richter@amd.com>
	<1333390758-10893-7-git-send-email-robert.richter@amd.com>
	<1334398906.2528.49.camel@twins>
	<20120423095659.GS9747@erda.amd.com>
	<20120427123434.GF18810@erda.amd.com>
	<CABPqkBS9FNmHBukzJqGJP1r5iqyLL9gz2g=3jvnt22pDxOdndA@mail.gmail.com>
	<20120427125410.GG18810@erda.amd.com>
	<CABPqkBTS2NkFqjVT9HgzPT=TTo9oOc__H9ZDDbXJK7WRpO0Vgg@mail.gmail.com>
	<20120427151852.GH18810@erda.amd.com>
	<1335540635.2463.134.camel@laptop>
Date: Fri, 27 Apr 2012 17:57:09 +0200
Message-ID: <CABPqkBTLODTnWQkdiysRnnThrz1OQweHfMFShgi3bwofestkmg@mail.gmail.com>
Subject: Re: [PATCH 06/12] perf/x86-ibs: Precise event sampling with IBS for
 AMD CPUs
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Robert Richter <robert.richter@amd.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 5:30 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2012-04-27 at 17:18 +0200, Robert Richter wrote:
>> There is nothing wrong with it. I already implemented that the
>> MISC_EXACT flag is supported. But, the flag is basically not used in
>> the perf tool and there is no modifier or so to only get a precise
>> rip.
>
> Just because userspace doesn't dtrt doesnt mean its a good idea to wreck
> the kernel side of things.
>
> Instead fix the userspace.
>
I was going to suggest you add an option to perf annotate/report to filter out
non exact_ip samples. That can't be that hard to do.


> I'll simply not take patches that silently drops samples.
>
