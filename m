Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab1BNOVp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:21:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:33122 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754084Ab1BNOVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:21:44 -0500
Date: Mon, 14 Feb 2011 15:21:27 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: Borislav Petkov <bp@amd64.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>, Tejun Heo <tj@kernel.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: fix section mismatch in reference from
 native_play_dead
Message-ID: <20110214142127.GD27076@elte.hu>
References: <20110203131333.GA4161@swordfish.minsk.epam.com>
 <20110214122550.GA15860@elte.hu>
 <20110214123244.GA4586@swordfish.minsk.epam.com>
 <20110214133210.GC9137@aftab>
 <20110214135217.GB4586@swordfish.minsk.epam.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110214135217.GB4586@swordfish.minsk.epam.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Sergey Senozhatsky <sergey.senozhatsky@gmail.com> wrote:

> On (02/14/11 14:32), Borislav Petkov wrote:
> > Right, but mwait_usable() is not __cpuinit anymore and __cpuinit
> > functions should be able to call other functions without annotation,
> > methinks, no?
> > 
> 
> Right,
> Agreed, Borislav's fix is the correct one.

Ok, thanks guys!

	Ingo
