Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab0KMPVp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 10:21:45 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:54038 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754214Ab0KMPVo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 10:21:44 -0500
Date: Sat, 13 Nov 2010 16:21:31 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Greg KH <gregkh@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [boot crash] Re: [GIT PATCH] TTY/serial fixes for .37-rc1
Message-ID: <20101113152131.GA2606@elte.hu>
References: <20101112213215.GB9294@kroah.com>
 <20101113151022.GA29085@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101113151022.GA29085@elte.hu>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0001]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Ingo Molnar <mingo@elte.hu> wrote:

> It crashed almost immediately after i merged Linus's 9457b24a0955 into -tip,
> we were on yesterday's f6614b7bb405 before that - so i think the crash is
> both pretty generic.

Yes, it crashes with an x86 defconfig too. Appears to be caused by:

 47d3904fe40d: 8250: Fix tcsetattr to avoid ioctl(TIOCMIWAIT) hang

It crashes any x86 serial console bootup.

Thanks,

	Ingo
