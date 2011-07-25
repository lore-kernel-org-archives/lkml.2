Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750970Ab1GYHak (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 03:30:40 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:51243 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751145Ab1GYHaf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 03:30:35 -0400
Date: Mon, 25 Jul 2011 09:29:49 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] x86, ioapic: Clean up ioapic/apic_id usage
Message-ID: <20110725072949.GC22518@elte.hu>
References: <4E1F0BC9.1040102@kernel.org>
 <CAErSpo5CzU2j81moWLsHDoRxTs5107=AEAWYi3ezy3Xfw86qiQ@mail.gmail.com>
 <4E29BEEA.4020600@kernel.org>
 <4E29BF14.9010302@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E29BF14.9010302@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Yinghai Lu <yinghai@kernel.org> wrote:

> 
> While looking at the code, apic_id sometime is referred to index of ioapic, but
> sometime is used for real apic id. and some even use apic for real apic id.
> It is very confusing.
> 
> So try to limit apic_id to be real apic id for ioapic.
> and use ioapic for ioapic index in the array.

Yes, consistency and unambiguity is good - please make it ioapic_id 
and ioapic_idx.

('apic_id' can be confused with a local APIC id, and 'ioapic' can be 
confused with an ioapic ID.)

Thanks,

	Ingo
