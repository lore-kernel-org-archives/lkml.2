Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab0FCNEz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 09:04:55 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:57051 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab0FCNEy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 09:04:54 -0400
Date: Thu, 3 Jun 2010 18:34:50 +0530
From: Srivatsa Vaddagiri <vatsa@in.ibm.com>
To: Nick Piggin <npiggin@suse.de>
Cc: Avi Kivity <avi@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       Gleb Natapov <gleb@redhat.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, hpa@zytor.com, mingo@elte.hu, tglx@linutronix.de,
       mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100603130450.GA26607@linux.vnet.ibm.com>
Reply-To: vatsa@in.ibm.com
References: <4C053ACC.5020708@redhat.com>
 <20100601172730.GB11880@basil.fritz.box>
 <4C05C722.1010804@redhat.com>
 <20100602085055.GA14221@basil.fritz.box>
 <4C061DAB.6000804@redhat.com>
 <20100603042051.GA5953@linux.vnet.ibm.com>
 <20100603103855.GG6822@laptop>
 <20100603120450.GH4035@linux.vnet.ibm.com>
 <20100603123832.GL6822@laptop>
 <20100603125821.GJ4035@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603125821.GJ4035@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 06:28:21PM +0530, Srivatsa Vaddagiri wrote:
> Ok got it - although that approach is not advisable in some cases for ex: when
> the lock holder vcpu and lock acquired vcpu are scheduled on the same pcpu by
> the hypervisor (which was experimented with in [1] where they foud a huge hit in
> perf).

1. http://lkml.org/lkml/2010/4/13/464

- vatsa
