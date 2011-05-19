Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932960Ab1ESJeJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 05:34:09 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:32859 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932629Ab1ESJeI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 05:34:08 -0400
Date: Thu, 19 May 2011 11:34:03 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        John Stultz <john.stultz@linaro.org>
Subject: Re: [patch 0/7] clocksources/clockevents improvements
Message-ID: <20110519093403.GD6251@elte.hu>
References: <20110518205713.947614271@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518205713.947614271@linutronix.de>
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


* Thomas Gleixner <tglx@linutronix.de> wrote:

> The series provides a few improvements to the core code of
> clocksources and clockevents.
> 
> 1) Better layout and cacheline alignment of the hotpath data in both
>    data structures
> 
> 2) Get rid of the hardcoded 5 seconds sleep limit in clocksources
> 
> 3) Provide a generic configuration and registration interface for
>    clockevents which does all the common math tasks so we can remove
>    copied code all over the place
> 
> 4) Provide a function to reconfigure an active clock event
>    device. Needed by devices which are affected by frequency scaling.
> 
> The last two patches are x86 specific and make use of the new
> config_register() functions.

Nice! Other than the comments i made for specific patches it's looking good to 
me:

Reviewed-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
