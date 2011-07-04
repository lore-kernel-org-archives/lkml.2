Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754658Ab1GDOKn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:10:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11018 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751842Ab1GDOKk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:10:40 -0400
Message-ID: <4E11C9CC.2070909@redhat.com>
Date: Mon, 04 Jul 2011 17:10:20 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
References: <1309362157-6596-1-git-send-email-avi@redhat.com> <1309362157-6596-2-git-send-email-avi@redhat.com> <20110629160841.GA2032@somewhere> <20110629162725.GH15521@e102144-lin.cambridge.arm.com> <20110704135820.GD5551@somewhere>
In-Reply-To: <20110704135820.GD5551@somewhere>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/2011 04:58 PM, Frederic Weisbecker wrote:
> Another thing I would like to do in the even longer term is to not use perf anymore
> for ptrace breakpoints, because that involves a heavy dependency and few people are
> happy with that. Instead we should just have a generic hook into the sched_switch()
> and handle pure ptrace breakpoints there. The central breakpoint API would still be
> there to reserve/schedule breakpoint resources between ptrace and perf.
>

'struct preempt_notifier' may be the hook you're looking for.

-- 
error compiling committee.c: too many arguments to function

