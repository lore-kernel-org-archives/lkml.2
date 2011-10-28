Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab1J1G7F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 02:59:05 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:47285 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab1J1G7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 02:59:04 -0400
Date: Fri, 28 Oct 2011 08:57:26 +0200
From: Ingo Molnar <mingo@elte.hu>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Chen Jie <chenj@lemote.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] time: Improve documentation of timekeeeping_adjust()
Message-ID: <20111028065726.GE12995@elte.hu>
References: <1319764362-32367-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319764362-32367-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
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


* John Stultz <john.stultz@linaro.org> wrote:

> After getting a number of questions in private emails about the
> math around admittedly very complex timekeeping_adjust() and
> timekeeping_big_adjust(), I  figure the code needs some better
> comments.
> 
> Hopefully the explanations are clear enough and don't muddy the water
> any worse.
> 
> Still needs documentation for ntp_error, but I couldn't recall
> exactly the full explanation behind the code that's there (although
> I do recall once working it out when Roman first proposed it).
> Given a bit more time I can probably work it out, but I don't want to
> hold back this documentation until then.
> 
> CC: Chen Jie <chenj@lemote.com>
> CC: Steven Rostedt <rostedt@goodmis.org>
> CC: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> ---
>  kernel/time/timekeeping.c |   81 ++++++++++++++++++++++++++++++++++++++++++++-
>  1 files changed, 80 insertions(+), 1 deletions(-)

Applied to tip:timers/core, thanks John.

	Ingo
