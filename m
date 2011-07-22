Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab1GVWjg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 18:39:36 -0400
Received: from 1wt.eu ([62.212.114.60]:37736 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752428Ab1GVWje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 18:39:34 -0400
Date: Sat, 23 Jul 2011 00:39:15 +0200
From: Willy Tarreau <w@1wt.eu>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ben Greear <greearb@candelatech.com>,
        Ingo Molnar <mingo@elte.hu>, John Stultz <john.stultz@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>, stable@kernel.org
Subject: Re: [stable] [patch 3/3] rtc: Limit frequency
Message-ID: <20110722223915.GA22405@1wt.eu>
References: <20110722091011.717194327@linutronix.de> <20110722091045.537404938@linutronix.de> <20110722150550.1878f069.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722150550.1878f069.akpm@linux-foundation.org>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 03:05:50PM -0700, Andrew Morton wrote:
> On Fri, 22 Jul 2011 09:12:51 -0000
> Thomas Gleixner <tglx@linutronix.de> wrote:
> 
> > The RTC hrtimer is self rearming. We really need to limit the
> > frequency to something sensible.
> 
> > Cc: stable@kernel.org
> 
> Why?  What failures does the current code cause?  What effect do these
> failures have upon users?

I would add that if we go that route, we should at least accept values
that were documented as possible till now. Man rtc says 2 Hz to 8192 Hz,
but Thomas' proposed patch limits it to 5000 Hz, so some breakage is to
be expected.

Regards,
Willy

