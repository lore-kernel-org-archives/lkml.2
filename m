Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752800Ab1GUP7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 11:59:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61124 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751569Ab1GUP7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 11:59:32 -0400
Message-ID: <4E284CC4.8060902@redhat.com>
Date: Thu, 21 Jul 2011 18:59:00 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc15 Thunderbird/3.1.11
MIME-Version: 1.0
To: Will Deacon <will.deacon@arm.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
References: <4E1BF5A1.5070301@redhat.com> <1310459898.18678.108.camel@twins> <4E1C0F02.9040906@redhat.com> <1310462046.14978.11.camel@twins> <4E1C10F8.6010300@redhat.com> <1310462335.14978.12.camel@twins> <4E1C1373.5080500@redhat.com> <1310463060.14978.17.camel@twins> <20110721153238.GC8446@e102144-lin.cambridge.arm.com> <4E28478B.1070907@redhat.com> <20110721154648.GD8446@e102144-lin.cambridge.arm.com>
In-Reply-To: <20110721154648.GD8446@e102144-lin.cambridge.arm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2011 06:46 PM, Will Deacon wrote:
> >
> >  This is (and must be) called from a preempt disabled context, no mutexes
> >  around here.
>
> Bah, yes, that is essential if you're dealing with current. Maybe use a
> spinlock instead?

Could work.  Not thrilled about adding it to the kvm hot path, but I 
can't say it will make a measurable impact.

-- 
error compiling committee.c: too many arguments to function

