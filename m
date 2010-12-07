Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754259Ab0LGIRe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 03:17:34 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41128 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751549Ab0LGIRd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 03:17:33 -0500
Date: Tue, 7 Dec 2010 08:17:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Jeff Ohlstein <johlstei@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        LKML <linux-kernel@vger.kernel.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        arve@android.com, David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Stepan Moskovchenko <stepanm@codeaurora.org>,
        Gregory Bean <gbean@codeaurora.org>,
        Steve Muckle <smuckle@codeaurora.org>
Subject: Re: [PATCH 3/5] msm: timer: SMP timer support for msm
Message-ID: <20101207081701.GA18336@n2100.arm.linux.org.uk>
References: <1291619778-30289-1-git-send-email-johlstei@codeaurora.org> <1291619778-30289-4-git-send-email-johlstei@codeaurora.org> <alpine.LFD.2.00.1012061025240.2653@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1012061025240.2653@localhost6.localdomain6>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 10:56:14AM +0100, Thomas Gleixner wrote:
> On Sun, 5 Dec 2010, Jeff Ohlstein wrote:
> > +#ifdef CONFIG_HOTPLUG_CPU
> > +void __cpuexit local_timer_stop(void)
> > +{
> > +	local_clock_event->set_mode(CLOCK_EVT_MODE_SHUTDOWN, local_clock_event);
> 
> Aarg. No. The generic code already handles cpu hotplug. 

Can you show where this is handled by the generic code?  I can't find
where this is handled.
