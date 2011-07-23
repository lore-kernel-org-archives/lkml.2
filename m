Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751350Ab1GWHbm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jul 2011 03:31:42 -0400
Received: from www.linutronix.de ([62.245.132.108]:52123 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750772Ab1GWHbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jul 2011 03:31:35 -0400
Date: Sat, 23 Jul 2011 09:31:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Rolando Martins <rolando.martins@gmail.com>
cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Subject: Re: [ANNOUNCE] 3.0-rt1
In-Reply-To: <CABcS5h01jpOSKcKtrJ65AqNNQDCAOutQADAE_pcRp-MPBoO-VA@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1107230930330.2702@ionos>
References: <alpine.LFD.2.02.1107222203400.2702@ionos> <CABcS5h01jpOSKcKtrJ65AqNNQDCAOutQADAE_pcRp-MPBoO-VA@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011, Rolando Martins wrote:

> Thanks for the great work!
> 
> Is it possible to have RT_GROUP_SCHED and PREEMPT_RT_FULL?

Not at the momenent. RT_GROUP_SCHED depends on !PREEMPT_RT_FULL
because it leads to yet undebugged hangs and failures.

Thanks,

	tglx
