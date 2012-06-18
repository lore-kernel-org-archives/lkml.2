Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751928Ab2FRLfz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:35:55 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57803 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2FRLfy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:35:54 -0400
Date: Mon, 18 Jun 2012 12:35:48 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-kernel@vger.kernel.org, Marc Zyngier <marc.zyngier@arm.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Will Deacon <will.deacon@arm.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, Ohad Ben-Cohen <ohad@wizery.com>,
        Peter Crosthwaite <peter.crosthwaite@petalogix.com>
Subject: Re: [RFC PATCH 5/8] AMP: smp: Extend number of IPIs
Message-ID: <20120618113548.GE12029@n2100.arm.linux.org.uk>
References: <1340019011-18642-1-git-send-email-monstr@monstr.eu> <1340019011-18642-6-git-send-email-monstr@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340019011-18642-6-git-send-email-monstr@monstr.eu>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 01:30:08PM +0200, Michal Simek wrote:
> GIC supports up to 16 IPIs.
> 
> Signed-off-by: Michal Simek <monstr@monstr.eu>
> 
> ---
> Please correct me if this code is also designed for different
> interrupt controller which doesn't support 16 IPIs.

This code is not specific to the GIC.  We use NR_IPI to indicate the
number of IPIs that the kernel actually uses, not the number which the
hardware provides.
