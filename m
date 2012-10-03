Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229Ab2JCEXH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 00:23:07 -0400
Received: from gate.crashing.org ([63.228.1.57]:52567 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841Ab2JCEXF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 00:23:05 -0400
Message-ID: <1349238166.3847.38.camel@pasglop>
Subject: Re: [REGRESSION] nfsd crashing with 3.6.0-rc7 on PowerPC
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Nishanth Aravamudan <nacc@linux.vnet.ibm.com>
Cc: Alexander Graf <agraf@suse.de>, LKML List <linux-kernel@vger.kernel.org>,
        anton@samba.org, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Date: Wed, 03 Oct 2012 14:22:46 +1000
In-Reply-To: <20121002214327.GA29218@linux.vnet.ibm.com>
References: <3BDA9E62-7031-42D6-8CA9-5327B61700F5@suse.de>
	 <CA+55aFyXwB1QcXE4Z_FAGnXROSgvP2x2+wjnX9OWPa4Dfaaf0A@mail.gmail.com>
	 <DC545CD9-8745-47DD-B13B-3385C0EB5B27@suse.de>
	 <20120928151043.GA19102@fieldses.org>
	 <2A52FC96-148C-4F7A-9950-E152E0C6698D@suse.de>
	 <1349139509.3847.2.camel@pasglop>
	 <20121002214327.GA29218@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-02 at 14:43 -0700, Nishanth Aravamudan wrote:
> 
> Started looking into this. If your suspicion were accurate, wouldn't
> the
> bisection have stopped at 0e4bc95d87394364f408627067238453830bdbf3
> ("powerpc/iommu: Reduce spinlock coverage in iommu_alloc and
> iommu_free")?
> 
> Alex, the error is reproducible, right? Does it go away by reverting
> that commit against mainline? Just trying to narrow down my focus.

My suspiction is, I'm afraid, a real bug but not that bug since it would
only happen on U3 and this is an U4 machine ... so we have two bugs, one
of them still unidentified.

Cleaning up the CC list for now...

Cheers,
Ben.

