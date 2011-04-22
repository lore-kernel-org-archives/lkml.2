Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab1DVNrM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 09:47:12 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:42689 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755537Ab1DVNrJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 09:47:09 -0400
Date: Fri, 22 Apr 2011 15:46:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Chris Samuel <chris@csamuel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, Yinghai Lu <yinghai@kernel.org>
Subject: Re: 2.6.38.3 and 2.6.39-rc4 hangs after "Booting the kernel" on quad
 Pentium Pro system
Message-ID: <20110422134648.GB23965@elte.hu>
References: <201104222333.25546.chris@csamuel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104222333.25546.chris@csamuel.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Chris Samuel <chris@csamuel.org> wrote:

> This box has given me good service over the past 8 years or
> so and I'd hate to have to retire it now due to this when I
> feel Linux should still work on it..
> 
> Any ideas please ?

Have you tried the earlyprintk=vga boot parameter yet? Maybe that shows more 
than just a silent hang ...

Other than that, do you have some other box where you can build bzImages for 
this system in reasonable time? If yes then you might be able to bisect to the 
commit that broke it.

Thanks,

	Ingo
