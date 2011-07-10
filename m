Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab1GJOTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 10:19:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42508 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752197Ab1GJOTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 10:19:53 -0400
Date: Sun, 10 Jul 2011 15:19:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Mattias Wallin <mattias.wallin@stericsson.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 0/3] clocksource: add db8500 PRCMU timer
Message-ID: <20110710141935.GA21414@n2100.arm.linux.org.uk>
References: <1307007271-1004-1-git-send-email-mattias.wallin@stericsson.com> <20110602094622.GS3660@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110602094622.GS3660@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 02, 2011 at 10:46:22AM +0100, Russell King - ARM Linux wrote:
> On Thu, Jun 02, 2011 at 11:34:31AM +0200, Mattias Wallin wrote:
> > The Multi Timer Unit (MTU) is currently used as clocksource and sched_clk
> > for the u8500 machine. The MTU block loose power during cpuidle sleep states
> > so an alternate clocksource is needed and these patches adds the db8500 PRCMU
> > timer.
> 
> Why don't we just find a way of fixing sched_clock so that the value
> doesn't reset over a suspend/resume cycle?  IOW, lets fix the problem
> for _everyone_ rather than only fixing it for one platform at a time.
> 
> Could you try this patch to check whether sched_clock() behaves better
> across a suspend/resume cycle please?

So do I merge this patch?
