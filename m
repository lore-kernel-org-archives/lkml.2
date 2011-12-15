Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755585Ab1LOHUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:20:53 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:52701 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751819Ab1LOHUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:20:51 -0500
Date: Thu, 15 Dec 2011 08:19:01 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Joerg Roedel <joerg.roedel@amd.com>
Subject: Re: Latest tip kernel(3.2-rc1-tip_cf6b3899) fails to boot on x3850x5
 machine
Message-ID: <20111215071901.GF14237@elte.hu>
References: <87ehw7ig2v.fsf@abhimanyu.in.ibm.com>
 <alpine.LFD.2.02.1112141423380.3020@ionos>
 <alpine.LFD.2.02.1112142116540.3020@ionos>
 <CAE9FiQXz6n=2gR1CY29pEbfbwx-e27WrUoDQeH9qxmL_kwP+mA@mail.gmail.com>
 <87y5ueo9m5.fsf@abhimanyu.in.ibm.com>
 <CAE9FiQXL3N6UZ6REfdUT_o1b-ed_KnYqKm_wSEhsaRPeaE9-9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE9FiQXL3N6UZ6REfdUT_o1b-ed_KnYqKm_wSEhsaRPeaE9-9Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=AWL,BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
	0.0 AWL                    AWL: From: address is in the auto white-list
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> On Wed, Dec 14, 2011 at 6:24 PM, Nikunj A Dadhania
> <nikunj@linux.vnet.ibm.com> wrote:
> >>
> >> BIOS pre-enabled x2apic, and kernel config does not have x2apic enabled?
> > make oldconfig somehow skipped this!! I can see my previous kernel config
> > having this enabled.
> 
> looks like recent dmar table related DMAR changing cause that.

Which one would that be? Perhaps:

      iommu: Rename the DMAR and INTR_REMAP config options

? They then need to be fixed if it can be done sanely.

Thanks,

	Ingo
