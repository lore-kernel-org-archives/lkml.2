Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932367Ab1GVWGL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 18:06:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56972 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753839Ab1GVWGK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 18:06:10 -0400
Date: Fri, 22 Jul 2011 15:05:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>, John Stultz <john.stultz@linaro.org>,
        Ingo Molnar <mingo@elte.hu>, Ben Greear <greearb@candelatech.com>,
        stable@kernel.org
Subject: Re: [patch 3/3] rtc: Limit frequency
Message-Id: <20110722150550.1878f069.akpm@linux-foundation.org>
In-Reply-To: <20110722091045.537404938@linutronix.de>
References: <20110722091011.717194327@linutronix.de>
	<20110722091045.537404938@linutronix.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Jul 2011 09:12:51 -0000
Thomas Gleixner <tglx@linutronix.de> wrote:

> The RTC hrtimer is self rearming. We really need to limit the
> frequency to something sensible.

> Cc: stable@kernel.org

Why?  What failures does the current code cause?  What effect do these
failures have upon users?


