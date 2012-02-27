Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab2B0HdF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 02:33:05 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:50668 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751107Ab2B0HdE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 02:33:04 -0500
Date: Mon, 27 Feb 2012 08:32:39 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Aaron Durbin <adurbin@google.com>, Paul Turner <pjt@google.com>,
        Yong Zhang <yong.zhang0@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Extend mwait idle to optimize away CAL and RES
 interrupts to an idle CPU -v2
Message-ID: <20120227073239.GA3397@elte.hu>
References: <1330122800-834-1-git-send-email-venki@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330122800-834-1-git-send-email-venki@google.com>
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


* Venkatesh Pallipadi <venki@google.com> wrote:

> [...] I did have to avoid x86 smpboot cleanup that Ingo 
> suggested as that did not seem trivial to me :-).

Well, idletask_ti_flags is unacceptably ugly, please do the 
smpboot.c cleanup because that paves the way to add new features 
to the x86 idle code.

Thanks,

	Ingo
