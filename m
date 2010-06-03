Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756208Ab0FCPRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 11:17:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:56383 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754363Ab0FCPRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 11:17:32 -0400
Date: Thu, 3 Jun 2010 17:17:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: Srivatsa Vaddagiri <vatsa@in.ibm.com>, Avi Kivity <avi@redhat.com>,
       Andi Kleen <andi@firstfloor.org>, Gleb Natapov <gleb@redhat.com>,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org, hpa@zytor.com,
       mingo@elte.hu, tglx@linutronix.de, mtosatti@redhat.com
Subject: Re: [PATCH] use unfair spinlock when running on hypervisor.
Message-ID: <20100603151730.GE4166@basil.fritz.box>
References: <20100601163807.GA11880@basil.fritz.box> <4C053ACC.5020708@redhat.com> <20100601172730.GB11880@basil.fritz.box> <4C05C722.1010804@redhat.com> <20100602085055.GA14221@basil.fritz.box> <4C061DAB.6000804@redhat.com> <20100603042051.GA5953@linux.vnet.ibm.com> <20100603103855.GG6822@laptop> <20100603120450.GH4035@linux.vnet.ibm.com> <20100603123832.GL6822@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100603123832.GL6822@laptop>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 03, 2010 at 10:38:32PM +1000, Nick Piggin wrote:
> And they aren't even using ticket spinlocks!!

I suppose they simply don't have unfair memory. Makes things easier.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
