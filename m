Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753888Ab1LLTXX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 14:23:23 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:59785 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753367Ab1LLTXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 14:23:22 -0500
Date: Mon, 12 Dec 2011 20:21:35 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Pekka Enberg <penberg@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
Message-ID: <20111212192135.GA18876@elte.hu>
References: <20111210132220.083204833@linutronix.de>
 <alpine.LFD.2.02.1112101715500.10936@tux.localdomain>
 <alpine.LFD.2.02.1112102144370.3020@ionos>
 <alpine.LFD.2.02.1112111014500.1663@tux.localdomain>
 <20111211103047.GA19299@elte.hu>
 <alpine.LFD.2.02.1112111459270.3020@ionos>
 <20111211155347.GA1297@elte.hu>
 <CAOJsxLHTuN43AGA7C02MtETzJU87y9cRaWRg6e9ER7NxOK2w-Q@mail.gmail.com>
 <20111212172059.GC23870@elte.hu>
 <CAOJsxLFk9Af+b4PAx_j+1QhApBsFdXyZY1aK08fb_6_dTiBEDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOJsxLFk9Af+b4PAx_j+1QhApBsFdXyZY1aK08fb_6_dTiBEDQ@mail.gmail.com>
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


* Pekka Enberg <penberg@kernel.org> wrote:

> So i'm pretty sure it's some bug in hw/serial.c that's 
> limiting character output by interrupts.

Serial port control flow somehow being bound by timer frequency 
[which is not really a necessity: both the host and the guest 
could stream on full speed] was too my observation early on.

Thanks,

	Ingo
