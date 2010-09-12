Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab0ILRyw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 13:54:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44144 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752004Ab0ILRyv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 13:54:51 -0400
Message-ID: <4C8D13CD.1060802@redhat.com>
Date: Sun, 12 Sep 2010 19:54:21 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100907 Fedora/3.1.3-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.3
MIME-Version: 1.0
To: Pavel Machek <pavel@ucw.cz>
CC: Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
        Tom Zanussi <tzanussi@gmail.com>,
        Fr?d?ric Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-perf-users@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: disabling group leader perf_event
References: <4C84B088.5050003@redhat.com> <1283772256.1930.303.camel@laptop> <4C84D1CE.3070205@redhat.com> <1283774045.1930.341.camel@laptop> <4C84D77B.6040600@redhat.com> <20100906124330.GA22314@elte.hu> <4C84E265.1020402@redhat.com> <20100906125905.GA25414@elte.hu> <4C850147.8010908@redhat.com> <20100906154737.GA4332@elte.hu> <20100912064612.GA1582@ucw.cz>
In-Reply-To: <20100912064612.GA1582@ucw.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/12/2010 08:46 AM, Pavel Machek wrote:
>   1- Most (least abstract) specific code: a block of bytecode in the form
>      of a simplified, executable, kernel-checked x86 machine code block -
>      this is also the fastest form. [yes, this is actually possible.]
> Well... if we want to be a bit x86-entric.... can we just reuse ACPI
> interpretter?

I hope this was a joke, ACPI won the academy awards for ugliness, 
slowness, low performance, bad specification, non-generality, and 
probably five other things I forgot.  Stay away from it as much as you can.

-- 
error compiling committee.c: too many arguments to function

