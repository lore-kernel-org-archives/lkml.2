Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1GLKYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 06:24:20 -0400
Received: from 8bytes.org ([88.198.83.132]:55489 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab1GLKYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 06:24:19 -0400
Date: Tue, 12 Jul 2011 12:24:17 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Avi Kivity <avi@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Will Deacon <will.deacon@arm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        "acme@ghostprotocols.net" <acme@ghostprotocols.net>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 1/3] perf: add context field to perf_event
Message-ID: <20110712102417.GD29812@8bytes.org>
References: <4E1C10F8.6010300@redhat.com> <1310462335.14978.12.camel@twins> <4E1C1373.5080500@redhat.com> <1310463060.14978.17.camel@twins> <20110712094131.GA29812@8bytes.org> <4E1C1771.9010300@redhat.com> <20110712094822.GB29812@8bytes.org> <4E1C1A0D.8000707@redhat.com> <20110712100354.GC29812@8bytes.org> <4E1C1CDD.9040005@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E1C1CDD.9040005@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 01:07:25PM +0300, Avi Kivity wrote:
> On 07/12/2011 01:03 PM, Joerg Roedel wrote:

>> Ingo made perf-integration a merge-requirement for LWP. It is not really
>> well-suited for being integrated into perf because the design goal was
>> easy and efficient self-profiling of tasks (like you stated). So
>> integrating it into perf causes some pain. But lets see how it works
>> out.
>
> I don't think it's workable.  Having do_mmap() called in the task's  
> context can change how it works.

According to Ingo that is already done at other places in the kernel and
should not be an issue.

> And the task being able to kill/modify  the profile, and not able to
> use LWP for itself, is a show stopper IMO.

I agree, that is a problem we have no solution for so far.

	Joerg

