Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab1EDGPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 02:15:18 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:51882 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752092Ab1EDGPQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 02:15:16 -0400
Date: Wed, 4 May 2011 08:14:58 +0200
From: Ingo Molnar <mingo@elte.hu>
To: werner <w.landgraf@ru.ru>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jaxboe@fusionio.com,
        tj@kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: 2.6.39-rc5-git2 boot crashs
Message-ID: <20110504061458.GA19049@elte.hu>
References: <web-517412206@zbackend1.aha.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <web-517412206@zbackend1.aha.ru>
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


* werner <w.landgraf@ru.ru> wrote:

> Enclosed also the screen fotos of the zip crash from now, and of the
> secondary reboot-resistent ata error which came back too.

All the oopses have scrolled off and the pictures are blurry, so it's not 
possible to see the backtraces clearly.

To prevent the scroll-off please add these boot options:

   pause_on_oops=600 initcall_debug debug ignore_loglevel

This should rate-limit the crash to one oops per 600 seconds. The first one is 
probably the most interesting one.

Also, does the vga=ask boot option added to the ones above work for you?

If yes then on bootup select a VGA mode that has as many lines as possible (to 
capture a big oops screen) - but in this case it's doubly important that the 
picture you take is *sharp*.

Thanks,

	Ingo
