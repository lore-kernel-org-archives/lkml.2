Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab2JVQIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 12:08:13 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:51747 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211Ab2JVQIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 12:08:12 -0400
MIME-Version: 1.0
In-Reply-To: <1350921565.2768.105.camel@twins>
References: <1350912052-10066-1-git-send-email-eranian@google.com>
	<1350912052-10066-2-git-send-email-eranian@google.com>
	<20121022135358.GJ2095@tassilo.jf.intel.com>
	<CABPqkBTJsZHdvp+Tm3SGJCfJ7eMFaqQR8pd9eoh5KyBo3k6o3Q@mail.gmail.com>
	<20121022153952.GM2095@tassilo.jf.intel.com>
	<CABPqkBTeuD==RY9xORYyUhtZm0cXAFw7FEPocMsdCbcqTUS3bg@mail.gmail.com>
	<1350921565.2768.105.camel@twins>
Date: Mon, 22 Oct 2012 18:08:10 +0200
Message-ID: <CABPqkBQ26K9iT6Kkzwg1XFvbz+ByKSoPGcyUDXrTq2+thqFBtA@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] perf tools: add event modifier to request
 exclusive PMU access
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <ak@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 5:59 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, 2012-10-22 at 17:44 +0200, Stephane Eranian wrote:
>>
>> I know the answer, because I know what's going on under the
>> hood. But what about the average user?
>
> I'm still wondering if the avg user really thinks 'instructions' is a
> useful metric for other than obtaining ipc measurements.
>
Yeah, for many users CPI (or IPC) is a useful metric.

> The avg user wants time domain measurements, like what's the most
> expensive function, or most expensive cache-miss etc..
>
Yes, you have those too.
