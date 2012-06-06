Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab2FFLqL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 07:46:11 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:57916 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751366Ab2FFLqJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 07:46:09 -0400
MIME-Version: 1.0
In-Reply-To: <4FCE9ADB.9000405@gmail.com>
References: <4FCE25C6.2080601@gmail.com>
	<1338912052.2749.2.camel@twins>
	<1338912312.2749.6.camel@twins>
	<4FCE3DE3.9060805@gmail.com>
	<1338917712.2749.24.camel@twins>
	<4FCE9ADB.9000405@gmail.com>
Date: Wed, 6 Jun 2012 13:46:07 +0200
Message-ID: <CABPqkBRDvg9AnSm0jR_JWst6Cy7Me0BgEK9E7=G92nLK87fJ9Q@mail.gmail.com>
Subject: Re: git bisect and perf
From: Stephane Eranian <eranian@google.com>
To: David Ahern <dsahern@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 1:48 AM, David Ahern <dsahern@gmail.com> wrote:
> Thanks for the explanation and patience.
>
>
> On 6/5/12 11:35 AM, Peter Zijlstra wrote:
>>
>> Now not all events the Intel PMU can do are PEBS capable; in fact most
>> aren't. So the whole cycles thing is about mapping the regular cycles
>> event to something that is PEBS capable.
>>
>
>
> I think I get it now. 7639dae0 is the commit I needed. With it 2.6.35.14 can
> do cycles:pp profiling.
>
> In general only the events listed in intel_XXXXX_pebs_events can be used
> with :p.
>
Yes.

> David
>
