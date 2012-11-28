Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754555Ab2K1LvR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 06:51:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:9758 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341Ab2K1LvQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 06:51:16 -0500
Date: Wed, 28 Nov 2012 09:39:30 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: MMU: lazily drop large spte
Message-ID: <20121128113930.GA29825@amt.cnet>
References: <20121114143747.GA7054@amt.cnet>
 <50A4267B.1030902@linux.vnet.ibm.com>
 <20121116030222.GA21822@amt.cnet>
 <50A5B560.2070604@linux.vnet.ibm.com>
 <20121116035655.GA27414@amt.cnet>
 <50A5C518.7030002@linux.vnet.ibm.com>
 <20121116095752.GA21401@amt.cnet>
 <50A799DA.7050900@linux.vnet.ibm.com>
 <20121118030040.GA5334@amt.cnet>
 <50B5A0CA.8060807@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50B5A0CA.8060807@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 01:27:38PM +0800, Xiao Guangrong wrote:
> On 11/18/2012 11:00 AM, Marcelo Tosatti wrote:
> map gfn 4?  See corrected step 7 above.
> >>
> >> Ah, this is a real bug, and unfortunately, it exists in current
> >> code. I will make a separate patchset to fix it. Thank you, Marcelo!
> > 
> > Is it? Hum..
> > 
> > Anyway, it would be great if you can write a testcase (should be similar
> > in size to rmap_chain).
> 
> Marcelo, is this patch acceptable?

Yes, can we get reexecute_instruction fix first? (which should then be
able to handle the case where a large read-only spte is created).

I'll merge the testcase later today.

