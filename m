Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab1ALTwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 14:52:10 -0500
Received: from smtp-out.google.com ([74.125.121.67]:26844 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab1ALTwI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 14:52:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=leds0W6Wt/FpYws1KCvr2LltKaD7S9LQK69IgbEJZmPtKXHAIecRzsFQyJEPqkIVb5
         l9gaKBQJWs2M950tpP3A==
MIME-Version: 1.0
In-Reply-To: <4D2E0403.7080300@linux.vnet.ibm.com>
References: <AANLkTim=jawJyBj0iFd0r4-LCKzvjFW+NddzJMD5GUB9@mail.gmail.com>
	<4D2E0403.7080300@linux.vnet.ibm.com>
Date: Wed, 12 Jan 2011 20:52:03 +0100
Message-ID: <AANLkTimwyzFKanSCeki3HOS95-cwWqGCAssX31DNWD3p@mail.gmail.com>
Subject: Re: [BUG] perf sched broken
From: Stephane Eranian <eranian@google.com>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        Robert Richter <robert.richter@amd.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 8:41 PM, Corey Ashford
<cjashfor@linux.vnet.ibm.com> wrote:
> On 01/12/2011 01:29 AM, Stephane Eranian wrote:
>>
>> Hi,
>>
>> I am trying to use perf sched from tip-x86 but it fails for all my
>> attempts.
>
> So far I have been unsuccessful in reproducing this problem, but I suspect
> that I have the wrong git tree or branch.  The git tree I've cloned is:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git
>
I was using this branch.
I also tried running the tool on ubuntu lucid (2.6.32-based).

Didn't you have to at least fixup the sched event names to drop :r?
Once you have the perf.data file, how do you dump it?

I tried:
- perf sched trace -> error
- perf sched replay -> error
- perf script sched-migration  -> hangs
- perf report -D

> I've tried the branches master, x86/urgent, and x86-urgent-for-linus. All of
> those produce correct results, as far as I can tell.
>
> Which tree / branch should I be using?
>
> - Corey
>
