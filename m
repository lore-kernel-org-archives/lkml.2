Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754007Ab2BUKRW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 05:17:22 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:57323 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752285Ab2BUKRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 05:17:21 -0500
Date: Tue, 21 Feb 2012 10:16:30 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, tglx@linutronix.de,
        plagnioj@jcrosoft.com, avictor.za@gmail.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: AIC and GPIO IRQ device tree initilization
Message-ID: <20120221101630.GI22562@n2100.arm.linux.org.uk>
References: <1329144189-4535-1-git-send-email-nicolas.ferre@atmel.com> <1329470878-14635-1-git-send-email-nicolas.ferre@atmel.com> <4F436C95.2040508@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F436C95.2040508@atmel.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 21, 2012 at 11:06:13AM +0100, Nicolas Ferre wrote:
> Grant, Rob,
> 
> I would like to have some feedback from you so that we will be able to
> build our DT related work on top of this series.
> 
> If you agree with this work, we may need to send it through arm-soc git
> tree. This will require to establish a dependency with Grant's irqdomain
> branch: do you think that it is stable enough?

That depends whether Grant has fixed the x86 regression with
drivers/mfd/twl-core.c yet.
