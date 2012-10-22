Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755418Ab2JVPoM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 11:44:12 -0400
Received: from mail-la0-f46.google.com ([209.85.215.46]:50908 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750913Ab2JVPoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 11:44:10 -0400
MIME-Version: 1.0
In-Reply-To: <20121022153952.GM2095@tassilo.jf.intel.com>
References: <1350912052-10066-1-git-send-email-eranian@google.com>
	<1350912052-10066-2-git-send-email-eranian@google.com>
	<20121022135358.GJ2095@tassilo.jf.intel.com>
	<CABPqkBTJsZHdvp+Tm3SGJCfJ7eMFaqQR8pd9eoh5KyBo3k6o3Q@mail.gmail.com>
	<20121022153952.GM2095@tassilo.jf.intel.com>
Date: Mon, 22 Oct 2012 17:44:08 +0200
Message-ID: <CABPqkBTeuD==RY9xORYyUhtZm0cXAFw7FEPocMsdCbcqTUS3bg@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] perf tools: add event modifier to request
 exclusive PMU access
From: Stephane Eranian <eranian@google.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        "mingo@elte.hu" <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 22, 2012 at 5:39 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> But maybe you're talking about a generic event exports in
>> /sys/device/cpu/events.
>> But why would I expose prec_dist there. And under what name?
>
> I already exposed it in the Haswell patchkit (instructions-p)
>
> I also exposed precise there so that some events can be forced PEBS
>
> If you want to expose it on Sandy Bridge too you need to add the
> event to the user tool grammar, like I did for precise.
>
> Then user can just use
>
> perf record -e instructions-p ...
>
> and the kernel does automagically the right thing.
>
Ok, I understand now.
But I am wondering what would be the meaning of:

$ perf stat -e instructions-p ...

I know the answer, because I know what's going on under the
hood. But what about the average user?
