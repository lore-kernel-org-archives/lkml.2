Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757449Ab1FUXLF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 19:11:05 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:37246 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757012Ab1FUXLC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 19:11:02 -0400
Date: Wed, 22 Jun 2011 00:10:35 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] ARM: smp: Fix the CPU hotplug race with scheduler.
Message-ID: <20110621231035.GE23802@n2100.arm.linux.org.uk>
References: <20110620114019.GH2082@n2100.arm.linux.org.uk> <20110620142338.GL2082@n2100.arm.linux.org.uk> <4DFF5F29.2000904@ti.com> <4E005F92.8030208@ti.com> <20110621100057.GB23802@n2100.arm.linux.org.uk> <4E006FA0.7050508@ti.com> <20110621101900.GC23802@n2100.arm.linux.org.uk> <4E00708C.6050108@ti.com> <20110621102600.GD23802@n2100.arm.linux.org.uk> <4E00FC2F.1010400@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E00FC2F.1010400@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 01:16:47PM -0700, Stephen Boyd wrote:
> On 06/21/2011 03:26 AM, Russell King - ARM Linux wrote:
> > On Tue, Jun 21, 2011 at 03:51:00PM +0530, Santosh Shilimkar wrote:
> >> On 6/21/2011 3:49 PM, Russell King - ARM Linux wrote:
> >>> I won't be committing the init/calibrate.c change to a git tree - it
> >>> isn't ARM stuff so it goes in patch form.
> >> Patches with change log would be fine as well.
> > The answer is not at the moment, but maybe soon.
> 
> Should we send those two patches to the stable trees as well? They seem
> to fix issues with cpu onlining that have existed for a long time.

Looks to me like the problem was introduced for 2.6.39-rc1, so we
should probably get the fix into the 2.6.39-stable tree too.
