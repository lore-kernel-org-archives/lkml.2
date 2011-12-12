Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1LLRVq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 12:21:46 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:48751 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826Ab1LLRVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 12:21:44 -0500
Date: Mon, 12 Dec 2011 18:20:00 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
Message-ID: <20111212172000.GB23870@elte.hu>
References: <20111210132220.083204833@linutronix.de>
 <alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
 <alpine.LFD.2.02.1112102144370.3020@ionos>
 <alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
 <20111211103047.GA19299@elte.hu>
 <alpine.LFD.2.02.1112111459270.3020@ionos>
 <20111211155347.GA1297@elte.hu>
 <1323667836.4190.4.camel@lappy>
 <20111212111222.GA21121@elte.hu>
 <20111212112052.30a568f7@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111212112052.30a568f7@pyramind.ukuu.org.uk>
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


* Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> > [*] Also, those 10K cycles include some significant Qemu 
> >     overhead - a couple of thousand cycles - that should be much 
> >     lower in the tools/kvm case.
> 
> Are all the traps going into qemu - is KVM still that braindead ?

I don't know what exactly Marcelo has measured - it seems a PIO 
trap handled by the VM monitor process - i.e. Qemu in that case.

Thanks,

	Ingo
