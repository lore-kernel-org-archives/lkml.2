Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751859Ab2FRLdu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:33:50 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57781 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2FRLds (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:33:48 -0400
Date: Mon, 18 Jun 2012 12:33:39 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Crosthwaite <peter.crosthwaite@petalogix.com>
Subject: Re: [RFC PATCH 1/8] ARM: gic: Support forcing cpumask for possible
	cpus in the system
Message-ID: <20120618113339.GC12029@n2100.arm.linux.org.uk>
References: <1340019011-18642-1-git-send-email-monstr@monstr.eu> <1340019011-18642-2-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340019011-18642-2-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 01:30:04PM +0200, Michal Simek wrote:
> gic_set_affinity doesn't support force option. Force option
> should work with all possible cpus in the system not only with
> online cpus.

Neither does x86.  Why do you want this?  Offline CPUs are unable to
receive the interrupt in any case (and must not receive interrupts in
the bringup path until they are online.)
