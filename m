Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849Ab1JLJs7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 05:48:59 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39443 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751343Ab1JLJs6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 05:48:58 -0400
Date: Wed, 12 Oct 2011 11:47:12 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Yinghai Lu <yinghai.lu@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Naga Chumbalkar <nagananda.chumbalkar@hp.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5 resend] x86, ioapic: Clean up ioapic idx and apic id
 usage
Message-ID: <20111012094711.GA21090@elte.hu>
References: <4E1F0BC9.1040102@kernel.org>
 <CAErSpo5CzU2j81moWLsHDoRxTs5107=AEAWYi3ezy3Xfw86qiQ@mail.gmail.com>
 <4E29BEEA.4020600@kernel.org>
 <20110725072831.GB22518@elte.hu>
 <4E95429E.2060100@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E95429E.2060100@oracle.com>
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



* Yinghai Lu <yinghai.lu@oracle.com> wrote:

> Resending x86/ioapic clean up patches.
> 
> it will make sure ioapic_idx is used instead of ioapic or apic_idx to used as index.
> 
> [PATCH 1/5] x86, ioapic: Passing irq_attr struct pointer with setup_ioapic_irq()
> [PATCH 2/5] x86, ioapic: Split setup_ioapic_entry for interrupt remapped version
> [PATCH 3/5] x86, ioapic: Print out irte with right ioapic index
> [PATCH 4/5] x86, ioapic: Seperate print_IO_APIC() to only print one io apic
> [PATCH 5/5] x86, ioapic: Clean up ioapic/apic_id usage
> 
> patch1, 2, 4, 5 are cleanup related
> patch3 fixes the one idx printout.

Applied to tip:x86/apic, thanks!

Another io_apic.c issue that Thomas raised is that we should 
standardize arch/x86 on SPARSE_IRQ=y and get rid of all
SPARSE_IRQ=n complications.

Thanks,

	Ingo
