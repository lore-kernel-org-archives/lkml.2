Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab2ESGFR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 02:05:17 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59594 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002Ab2ESGFN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 02:05:13 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH v2 1/5] i2c: Convert i2c-octeon.c to use device tree.
To: David Daney <ddaney.cavm@gmail.com>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        linux-i2c@vger.kernel.org
In-Reply-To: <1335489630-27017-2-git-send-email-ddaney.cavm@gmail.com>
References: <1335489630-27017-1-git-send-email-ddaney.cavm@gmail.com> <1335489630-27017-2-git-send-email-ddaney.cavm@gmail.com>
Date: Sat, 19 May 2012 00:05:09 -0600
Message-Id: <20120519060509.DAD0F3E046E@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Apr 2012 18:20:26 -0700, David Daney <ddaney.cavm@gmail.com> wrote:
> From: David Daney <david.daney@cavium.com>
> 
> There are three parts to this:
> 
> 1) Remove the definitions of OCTEON_IRQ_TWSI and OCTEON_IRQ_TWSI2.
>    The interrupts are specified by the device tree and these hard
>    coded irq numbers block the used of the irq lines by the irq_domain
>    code.
> 
> 2) Remove platform device setup code from octeon-platform.c, it is
>    now unused.
> 
> 3) Convert i2c-octeon.c to use device tree.  Part of this includes
>    using the devm_* functions instead of the raw counterparts, thus
>    simplifying error handling.  No functionality is changed.
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> Acked-by: Rob Herring <rob.herring@calxeda.com>

Is the DT binding for this device documented?

Otherwise the code looks good.  Please make sure the binding
documentation is in place before merging.

g.

