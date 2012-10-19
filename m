Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932990Ab2JSPSA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:18:00 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:57767 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932269Ab2JSPR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:17:59 -0400
MIME-Version: 1.0
In-Reply-To: <1350659619.2768.30.camel@twins>
References: <1350658326-14715-1-git-send-email-eranian@google.com>
	<1350658326-14715-2-git-send-email-eranian@google.com>
	<1350659619.2768.30.camel@twins>
Date: Fri, 19 Oct 2012 17:17:57 +0200
Message-ID: <CABPqkBSzwNYHS22xaw2zP0e3QAROSRL0v-K29qxjW1By1iK6pw@mail.gmail.com>
Subject: Re: [PATCH 1/2] perf tools: add event modifier to request exclusive
 PMU access
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 5:13 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2012-10-19 at 16:52 +0200, Stephane Eranian wrote:
>> -modifier_event [ukhpGH]{1,8}
>> +modifier_event [ukhpGHx]{1,8}
>
> wouldn't the max modifier sting length grow by adding another possible
> modifier?

That's what I thought too, but then I don't understand why it was at
eight before and not
seven: One instance of each letter, + a second for pp (precise=2). Or
am I missing
something here?
