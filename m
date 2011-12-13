Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab1LMKjO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 05:39:14 -0500
Received: from www.linutronix.de ([62.245.132.108]:56890 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134Ab1LMKjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 05:39:11 -0500
Date: Tue, 13 Dec 2011 11:38:58 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: john.stultz@linaro.org, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, cschan@codeaurora.org,
        sboyd@codeaurora.org, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [tip:core/debugobjects] debugobjects: Be smarter about static
 objects
In-Reply-To: <tip-feac18dda25134005909e7770c77464e65608bd8@git.kernel.org>
Message-ID: <alpine.LFD.2.02.1112131137130.3020@ionos>
References: <1320724108-20788-2-git-send-email-sboyd@codeaurora.org> <tip-feac18dda25134005909e7770c77464e65608bd8@git.kernel.org>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen,

On Mon, 28 Nov 2011, tip-bot for Stephen Boyd wrote:

> Commit-ID:  feac18dda25134005909e7770c77464e65608bd8
> Gitweb:     http://git.kernel.org/tip/feac18dda25134005909e7770c77464e65608bd8
> Author:     Stephen Boyd <sboyd@codeaurora.org>
> AuthorDate: Mon, 7 Nov 2011 19:48:26 -0800
> Committer:  Thomas Gleixner <tglx@linutronix.de>
> CommitDate: Wed, 23 Nov 2011 18:49:22 +0100
> 
> debugobjects: Be smarter about static objects
> 
> Make debugobjects use the return code from the fixup function. That
> allows us better diagnostics in the activate check than relying on a
> WARN_ON() in the object specific code.

that series wreckaged the debugobjects selftest. Can you please have a
look?

[    0.000000] ODEBUG: selftest warnings failed 4 != 5

Thanks,

	tglx
