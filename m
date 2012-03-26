Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933048Ab2CZRFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 13:05:46 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37915 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932699Ab2CZRFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 13:05:43 -0400
MIME-Version: 1.0
In-Reply-To: <1332781439.6160.100.camel@joe2Laptop>
References: <1332775946-2162-1-git-send-email-consul.kautuk@gmail.com>
	<1332778595.6160.84.camel@joe2Laptop>
	<CAFPAmTSyYJkATAD32WqHZY_PdWGjitEq4vgqCZeqjo+V24dh3Q@mail.gmail.com>
	<1332779529.6160.96.camel@joe2Laptop>
	<CAFPAmTTAf660w7Xcidzi5KHrJoDSEiWJdOMhyUesGxih8bs1wA@mail.gmail.com>
	<1332781439.6160.100.camel@joe2Laptop>
Date: Mon, 26 Mar 2012 13:05:43 -0400
Message-ID: <CAFPAmTQbm7LUvbt4NWAmL_4g=7b7cnFjv6NowoaSn9oZTwWVmg@mail.gmail.com>
Subject: Re: [PATCH 19/20 v3] sparc/mm/fault_32.c: Port OOM changes to do_sparc_fault
From: Kautuk Consul <consul.kautuk@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: davem@davemloft.net, Paul Gortmaker <paul.gortmaker@windriver.com>,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 1:03 PM, Joe Perches <joe@perches.com> wrote:
> On Mon, 2012-03-26 at 12:55 -0400, Kautuk Consul wrote:
>> Is it possible to include this kinda checking
>> (multiline statements with paranthesis checking assuming tab
>> indentation 8) in the
>> checkpatch.pl script ?
>> It would be easier to not make such mistakes in future with that kind of tool.
>
> Funny you should ask...
>
> Use the latest version of checkpatch and
> add the --strict option to the command line.
>
> https://lkml.org/lkml/2012/3/2/15
>
> It works for most cases.
>

Ah yes, I am not in the habit of using the --strict option.
I will use that in future, sorry for my ignorance.

And thanks to all you guys for helping me out here. :)
