Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab1LNA1G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 19:27:06 -0500
Received: from www.linutronix.de ([62.245.132.108]:59269 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751909Ab1LNA1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 19:27:03 -0500
Date: Wed, 14 Dec 2011 01:26:49 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Dima Zavin <dima@android.com>
cc: Stepan Moskovchenko <stepanm@codeaurora.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Frank Rowand <frank.rowand@am.sony.com>,
        amit kachhap <amit.kachhap@linaro.org>,
        Colin Cross <ccross@android.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        chaos.youn@samsung.com, LAK <linux-arm-kernel@lists.infradead.org>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Re: [patch] ARM: smpboot: Enable interrupts after marking CPU
 online/active
In-Reply-To: <CAPz4a6BwzAmE=08pCfhK5of0vEV+uPaf8D-9U_MnW5_vAe6NFw@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1112140124480.3020@ionos>
References: <20110908215314.829452535@linutronix.de> <CADGdYn6V_eQJZ4=irMbSS7XJj4MJVeALxcrWdD7o2bGs1sEJZQ@mail.gmail.com> <20110913133258.GA6267@n2100.arm.linux.org.uk> <CAKfTPtCWuiOM5+sOwdh1FzXZb1EFT__tVEpRPY5suGOxpYTdQQ@mail.gmail.com>
 <20110913175312.GB6267@n2100.arm.linux.org.uk> <20110923084001.GP17169@n2100.arm.linux.org.uk> <01d501cc84d6$62720890$275619b0$%kim@samsung.com> <alpine.LFD.2.02.1110071354310.3240@ionos> <CAPz4a6CkOXp6LHX2hFYVBhXWT4rhCUzLyYTLbO7g8u_jYcHt7Q@mail.gmail.com>
 <CAPz4a6C7md+k8pCz6mJtB-v_1h-faGxQZkOqU9vHUtcG-jrYVQ@mail.gmail.com> <4EC2DF93.2050904@codeaurora.org> <alpine.LFD.2.02.1111152259430.4902@ionos> <CAPz4a6BwzAmE=08pCfhK5of0vEV+uPaf8D-9U_MnW5_vAe6NFw@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Dec 2011, Dima Zavin wrote:

> Thomas,
> 
> Did you ever get a chance to look into this further?

Yes, Peter and I are still debating the proper solution as this does
not only affect ARM. It looks like most of arch/* implementations are
hosed in one way or the other. Funny enough Peter and I put this on to
the tomorrow todo list a few hours ago.

Thanks,

	tglx
