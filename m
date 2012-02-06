Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766Ab2BFObE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 09:31:04 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53172 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753755Ab2BFObC convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 09:31:02 -0500
MIME-Version: 1.0
In-Reply-To: <1328538403.2482.4.camel@laptop>
References: <20120206132546.GA30854@quad>
	<1328538403.2482.4.camel@laptop>
Date: Mon, 6 Feb 2012 15:31:00 +0100
Message-ID: <CABPqkBRXc989vxb99S2y4thppjp8tFAxjWhCyC1Hvb897-s3EQ@mail.gmail.com>
Subject: Re: [BUG] perf: perf sched warning possibly due to clock granularity
 on AMD
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, mingo@elte.hu,
        robert.richter@amd.com, eric.dumazet@gmail.com,
        Borislav Petkov <bp@amd64.org>
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 6, 2012 at 3:26 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-02-06 at 14:25 +0100, Stephane Eranian wrote:
>> In summary, two issues:
>>   - Why is sched_clock_stable not set or even tested on recent AMD systems?
>
> I'll leave that for Robert to answer, also added Boris to the CC, him
> know AMD bits too.
>
Ok, good.

>>   - perf should not rely on fine granularity timestamps in the re-ordering code
>
> Uhm, what else is there?
I understand your point. I don't quite understand what the code is
supposed to do for odered
samples. I'd like Arnaldo to explain this warning first.
