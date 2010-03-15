Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936931Ab0COV7T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 17:59:19 -0400
Received: from mga14.intel.com ([143.182.124.37]:59625 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936892Ab0COV7R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 17:59:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,645,1262592000"; 
   d="scan'208";a="500861263"
Subject: Re: [patch] x86: handle legacy PIC interrupts on all the cpu's
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>
In-Reply-To: <4B9EABE8.1020203@kernel.org>
References: <1268692386.3296.43.camel@sbs-t61.sc.intel.com>
	 <4B9EABE8.1020203@kernel.org>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 15 Mar 2010 14:56:11 -0800
Message-Id: <1268693771.3296.49.camel@sbs-t61.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-03-15 at 14:51 -0700, Yinghai Lu wrote:
> > +	for (irq = 0; irq < legacy_pic->nr_legacy_irqs; irq++)
> > +		if (!IO_APIC_IRQ(irq))
> > +			per_cpu(vector_irq, cpu)[IRQ0_VECTOR + irq] = irq;
> 
> seems those three lines are not needed...

Those are needed for !CONFIG_X86_IO_APIC case.

thanks,
suresh

