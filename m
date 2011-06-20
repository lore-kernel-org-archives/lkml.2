Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752618Ab1FTKoe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 06:44:34 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56347 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752254Ab1FTKod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 06:44:33 -0400
Date: Mon, 20 Jun 2011 11:44:15 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Santosh Shilimkar <santosh.shilimkar@ti.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH] ARM: smp: Fix the CPU hotplug race with scheduler.
Message-ID: <20110620104415.GF2082@n2100.arm.linux.org.uk>
References: <1308561839-18407-1-git-send-email-santosh.shilimkar@ti.com> <20110620095053.GA2082@n2100.arm.linux.org.uk> <20110620101438.GD2082@n2100.arm.linux.org.uk> <4DFF20B3.7010209@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFF20B3.7010209@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 03:58:03PM +0530, Santosh Shilimkar wrote:
> No it doesn't work. I still get the crash. The important point
> here is not to enable interrupts before CPU is marked
> as online and active.

What is the crash (in full please)?

Do we know what interrupt is causing it?
