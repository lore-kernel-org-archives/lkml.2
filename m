Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833Ab1GLKgj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 06:36:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33541 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751553Ab1GLKgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 06:36:38 -0400
Message-ID: <4E1C2397.9040005@redhat.com>
Date: Tue, 12 Jul 2011 13:36:07 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, Will Deacon <will.deacon@arm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
References: <4E1C10F8.6010300@redhat.com> <1310462335.14978.12.camel@twins> <4E1C1373.5080500@redhat.com> <1310463060.14978.17.camel@twins> <20110712094131.GA29812@8bytes.org> <4E1C1771.9010300@redhat.com> <20110712094822.GB29812@8bytes.org> <4E1C1A0D.8000707@redhat.com> <20110712100354.GC29812@8bytes.org> <4E1C1CDD.9040005@redhat.com> <20110712102417.GD29812@8bytes.org>
In-Reply-To: <20110712102417.GD29812@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2011 01:24 PM, Joerg Roedel wrote:
> On Tue, Jul 12, 2011 at 01:07:25PM +0300, Avi Kivity wrote:
> >  On 07/12/2011 01:03 PM, Joerg Roedel wrote:
>
> >>  Ingo made perf-integration a merge-requirement for LWP. It is not really
> >>  well-suited for being integrated into perf because the design goal was
> >>  easy and efficient self-profiling of tasks (like you stated). So
> >>  integrating it into perf causes some pain. But lets see how it works
> >>  out.
> >
> >  I don't think it's workable.  Having do_mmap() called in the task's
> >  context can change how it works.
>
> According to Ingo that is already done at other places in the kernel and
> should not be an issue.

kvm is one of those places, unfortunately.


-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

