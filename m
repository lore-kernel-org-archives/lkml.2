Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751319Ab2I3LJL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Sep 2012 07:09:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751211Ab2I3LIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Sep 2012 07:08:13 -0400
Date: Sun, 30 Sep 2012 13:07:55 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Jiannan Ouyang <ouyang@cs.pitt.edu>,
        Peter Zijlstra <peterz@infradead.org>, Rik van Riel <riel@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
Message-ID: <20120930110755.GB1009@redhat.com>
References: <505CA2EB.7050403@linux.vnet.ibm.com>
 <50607F1F.2040704@redhat.com>
 <5060851E.1030404@redhat.com>
 <506166B4.4010207@linux.vnet.ibm.com>
 <5061713D.5060406@redhat.com>
 <CAJocwcf+8u84_yDC-PK0Yni93YSTWzYvr69nq6b3pNv1MwVJzQ@mail.gmail.com>
 <50641356.5070008@redhat.com>
 <CAJocwcc19F+PtsQ5okGMvYeVnkEigpZRpwWY9JgeRPFqfcVoXA@mail.gmail.com>
 <506540C7.9070105@linux.vnet.ibm.com>
 <50680049.5020206@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50680049.5020206@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 30, 2012 at 10:18:17AM +0200, Avi Kivity wrote:
> On 09/28/2012 08:16 AM, Raghavendra K T wrote:
> > 
> >>
> >>     +struct pv_sched_info {
> >>     +       unsigned long   sched_bitmap;
> > 
> > Thinking, whether we need something similar to cpumask here?
> > Only thing is we are representing guest (v)cpumask.
> > 
> 
> DECLARE_BITMAP(sched_bitmap, KVM_MAX_VCPUS)
> 
vcpu_id can be greater than KVM_MAX_VCPUS.

> cpumask is for host masks, this is a guest mask.
> 
> -- 
> error compiling committee.c: too many arguments to function

--
			Gleb.
