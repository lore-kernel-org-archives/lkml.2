Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758594Ab2K0JJM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 04:09:12 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:44884 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758423Ab2K0JJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 04:09:10 -0500
Date: Tue, 27 Nov 2012 01:05:56 -0800
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Shiyan <shc_work@mail.ru>, Arnd Bergmann <arnd@arndb.de>,
        linaro-kernel@lists.linaro.org, Russell King <linux@arm.linux.org.uk>,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        John Stultz <john.stultz@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>, kernel-team@android.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 10/10] ARM: FIQ: Get rid of init_FIQ()
Message-ID: <20121127090553.GA12289@lizard>
References: <20121123003849.GA973@lizard.mcd25758.sjc.wayport.net>
 <1353652071.755665772@f76.mail.ru>
 <20121123065002.GB27827@lizard>
 <1353656161.911816605@f287.mail.ru>
 <20121123075138.GA2136@lizard>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20121123075138.GA2136@lizard>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 11:51:38PM -0800, Anton Vorontsov wrote:
> On Fri, Nov 23, 2012 at 11:36:01AM +0400, Alexander Shiyan wrote:
> [...]
> > got_no_fiq_insn also not initialized.
> 
> It is static, so by definition it is initialized to 0.
> 
> > I think as a whole on this issue requires additional comments from Russell
> > as the author of implementation.
> > 
> > PS: In any case, I can reproduce it and check it out if you send me a patchset
> > to my email as an attachment.
> 
> Sent privately.

Andrew, Arnd, just FYI, it works for Alexander.

----- Forwarded message from Alexander Shiyan <shc_work@mail.ru> -----
Date: Tue, 27 Nov 2012 12:42:50 +0400
From: Alexander Shiyan <shc_work@mail.ru>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: Re[2]: FIQ

> Hello Alexander,
> 
> On Tue, Nov 27, 2012 at 12:14:28PM +0400, Alexander Shiyan wrote:
> > Sorry, I lost the original message to the correct answer.
> > Today I had a test of removal init_FIQ.
> > The test took place on a custom board with a custom ARM CLPS711X OSS audio
> > driver, which uses the FIQ interrupts. Everything works fine.
> 
> Nice! Thanks a lot for testing!
> 
> Can you please reply to the original thread, with the
> 
> 	Tested-by: Alexander Shiyan <shc_work@mail.ru>
> ?
> 
> This will help pushing the series forward, plus will give you a credit for
> your efforts.

I am lost thread in my mailbox, you can just copy/paste my reply and ping for Arnd.

