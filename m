Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932642Ab1GVWEw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 18:04:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:53560 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932314Ab1GVWEv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 18:04:51 -0400
Date: Fri, 22 Jul 2011 15:04:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, Ben Greear <greearb@candelatech.com>,
        stable@kernel.org
Subject: Re: [patch 1/3] rtc: Handle errors correctly in rtc_irq_set_state()
Message-Id: <20110722150432.2370bcf2.akpm@linux-foundation.org>
In-Reply-To: <20110722091045.403648377@linutronix.de>
References: <20110722091011.717194327@linutronix.de>
	<20110722091045.403648377@linutronix.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011 09:12:50 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> The code checks the correctness of the parameters, but unconditionally
> arms/disarms the hrtimer.
> 
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: stable@kernel.org

The -stable maintainers will want to know why they should merge this.

The maintainers of other trees will wonder whether they should backport
it too.

To help them make these decision we should always provide a description
of the user-visible effects of the bug, please.


