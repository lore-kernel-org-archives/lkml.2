Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab2GADK0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 23:10:26 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64347 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754610Ab2GADKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 23:10:25 -0400
Message-ID: <4FEFBF93.3010608@gmail.com>
Date: Sun, 01 Jul 2012 11:10:11 +0800
From: Nai Xia <nai.xia@gmail.com>
Reply-To: nai.xia@gmail.com
Organization: NJU
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: dlaor@redhat.com, Andrea Arcangeli <aarcange@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Dan Smith <danms@us.ibm.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Rik van Riel <riel@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>
Subject: Re: [PATCH 13/40] autonuma: CPU follow memory algorithm
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com>  <1340888180-15355-14-git-send-email-aarcange@redhat.com>  <1340895238.28750.49.camel@twins>  <CAJd=RBA+FPgB9iq07YG0Pd=tN65SGK1ifmj98tomBDbYeKOE-Q@mail.gmail.com>  <20120629125517.GD32637@gmail.com> <4FEDDD0C.60609@redhat.com>  <1340995986.28750.114.camel@twins>  <CAPQyPG4R34bi0fXHBspSpR1+gDLj2PGYpPXNLPTTTBmrRL=m4g@mail.gmail.com>  <20120630012338.GY6676@redhat.com>  <CAPQyPG7Nx1Jdq7WBBDC41iRGOMx8CdQjcWTNOWyj1fzVeuRcgw@mail.gmail.com>  <4FEE9310.1050908@redhat.com>  <CAPQyPG50wtowNsPm1UADCNchY-gFk-cKW8oiU34L2REybhNoEg@mail.gmail.com> <1341100552.2563.48.camel@pasglop>
In-Reply-To: <1341100552.2563.48.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2012年07月01日 07:55, Benjamin Herrenschmidt wrote:
> On Sat, 2012-06-30 at 14:58 +0800, Nai Xia wrote:
>> If you insist on ignoring any constructive suggestions from others,
>
> But there is nothing constructive about your criticism.
>
> You are basically saying that the whole thing cannot work unless it's
> based on 20 years of research. Duh !

1. You quote me wrong: I said "group all pages to one node" is correct,
and highly possible to play the major role in your benchmarks.
Sampling is completely broken from my point of view. PZ's patch also
has similar idea of "group all pages to one node" which I think
is also correct.

2. My suggestion to Andrea: Do some more comparative benchmarks to
see what's really happening inside, instead of only macro benchmarks.
You need to have 20 hours of carefully designed survey research
for a new algorithm, instead of reading my mail and spending 20min
to give a conclusion.

If you cannot see the constructiveness of my suggestion. That's
your problem, not mine.

I understand the hard feelings of seeing the possible brokenness of a
thing you've already spend a lot of time. But that's the way people
seeking for truth.

You see, you guys has spent quite sometime to defend your points,
if this time were used to follow my advise doing some further
analysis maybe you've already got some valuable information.

Dor was right, we all made our points. And we are all busy.
Let's stop it. Thanks.

>
> Ben.
>
>
