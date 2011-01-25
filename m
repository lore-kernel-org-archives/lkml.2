Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751547Ab1AYATy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 19:19:54 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:55351 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab1AYATx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 19:19:53 -0500
Date: Tue, 25 Jan 2011 01:19:40 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alexander Gordeev <lasaine@lvk.cs.msu.su>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] pps: claim parallel port exclusively
Message-ID: <20110125001940.GD17623@elte.hu>
References: <20110121194317.GA8908@elte.hu>
 <5f4d478f7f5ec0e0734b29e6f35c635c86a2488d.1295912692.git.lasaine@lvk.cs.msu.su>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5f4d478f7f5ec0e0734b29e6f35c635c86a2488d.1295912692.git.lasaine@lvk.cs.msu.su>
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


* Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:

> Both pps_parport and pps_gen_parport are written in a way that they
> can't share a port with any other driver. This can result in locking up
> the process that loads modules or even the whole kernel if the modules
> are compiled in. Use PARPORT_FLAG_EXCL to indicate this.
> 
> Signed-off-by: Alexander Gordeev <lasaine@lvk.cs.msu.su>

Thanks Alexander - i think the bug you fixed here explains the symptoms i was 
seeing.

Consider the bug fixed - i'll yell if something else pops up in testing.

Thanks,

	Ingo
