Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756125Ab1JRIjr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 04:39:47 -0400
Received: from www.linutronix.de ([62.245.132.108]:57934 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab1JRIjq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 04:39:46 -0400
Date: Tue, 18 Oct 2011 10:39:40 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Simon Kirby <sim@hostway.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 3.1-rc9
In-Reply-To: <alpine.LFD.2.02.1110172237030.3240@ionos>
Message-ID: <alpine.LFD.2.02.1110181037120.3240@ionos>
References: <CA+55aFxPNszU5UHFrDDYnshLEMupaviFwhgEsgmPkqpmuWNZ8A@mail.gmail.com>  <20111007070842.GA27555@hostway.ca> <20111007174848.GA11011@hostway.ca>  <1318010515.398.8.camel@twins> <20111008005035.GC22843@hostway.ca>  <1318060551.8395.0.camel@twins>
 <20111012213555.GC24461@hostway.ca>  <20111013232521.GA5654@hostway.ca>  <CA+55aFxxfsFMgqA7kYKukvkCX6Z9HrKOtP-22w5Mc21iQj4c=Q@mail.gmail.com>  <1318847658.6594.40.camel@twins>  <CA+55aFxaGKEyhXdHXNxvPrPQ-SGSpbXdfoeXrxfjPx3VXsgvtg@mail.gmail.com> 
 <1318874090.4172.84.camel@twins>  <CA+55aFwCBy=4YK6amE=H-BYu9-boj4Po2Zkgf4V261mCx0DC4A@mail.gmail.com> <1318879396.4172.92.camel@twins> <alpine.LFD.2.02.1110172237030.3240@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, Thomas Gleixner wrote:
> That said, I really need some sleep before I can make a final
> judgement on that horror. The call paths are such an intermingled mess
> that it's not funny anymore. I do that tomorrow morning first thing.

The patch is safe and the exit race just existed in my confused tired
brain. Peter, can you please provide a changelog. That wants a cc
stable as well, because that deadlock causing commit hit 3.0.7 :(

Thanks,

	tglx
