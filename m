Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab0IFR41 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Sep 2010 13:56:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752324Ab0IFR4V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Sep 2010 13:56:21 -0400
Message-ID: <4C852B2A.2030103@redhat.com>
Date: Mon, 06 Sep 2010 20:55:54 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@cs.helsinki.fi>, Tom Zanussi <tzanussi@gmail.com>,
        =?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?= <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
References: <4C84B088.5050003@redhat.com> <1283772256.1930.303.camel@laptop> <4C84D1CE.3070205@redhat.com> <1283774045.1930.341.camel@laptop> <4C84D77B.6040600@redhat.com> <20100906124330.GA22314@elte.hu> <4C84E265.1020402@redhat.com> <20100906125905.GA25414@elte.hu> <4C850147.8010908@redhat.com> <20100906154737.GA4332@elte.hu>
In-Reply-To: <20100906154737.GA4332@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/06/2010 06:47 PM, Ingo Molnar wrote:
>
>> The actual language doesn't really matter.
> There are 3 basic categories:
>
>   1- Most (least abstract) specific code: a block of bytecode in the form
>      of a simplified, executable, kernel-checked x86 machine code block -
>      this is also the fastest form. [yes, this is actually possible.]

Do you then recompile it?  x86 is quite unpleasant.

>   2- Least specific (most abstract) code: A subset/sideset of C - as it's
>      the most kernel-developer-trustable/debuggable form.
>
>   3- Everything else little more than a dot on the spectrum between the
>      first two points.
>
> I lean towards #2 - but #1 looks interesting too. #3 is distinctly
> uninteresting as it cannot be as fast as #1 and cannot be as convenient
> as #2.

Curious - how do you guarantee safety of #1 or even #2?  Can you point 
me to any research?

Everything I'm aware of is bytecode with explicit measures to prevent 
forged pointers, but I admit I've spent no time on it.  It's interesting 
stuff, though.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

