Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab1IUJdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 05:33:43 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:12548
	"EHLO DB3EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753480Ab1IUJdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 05:33:39 -0400
X-SpamScore: -9
X-BigFish: VS-9(zz1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPVD:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
Date: Wed, 21 Sep 2011 17:43:14 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: <linux-arm-kernel@lists.infradead.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <dave.martin@linaro.org>, <linux@arm.linux.org.uk>, <b-cousson@ti.com>,
        <marc.zyngier@arm.com>, Rob Herring <rob.herring@calxeda.com>,
        <grant.likely@secretlab.ca>, <thomas.abraham@linaro.org>,
        <jamie@jamieiles.com>, <shawn.guo@linaro.org>
Subject: Re: [PATCH 0/3] GIC OF bindings
Message-ID: <20110921094313.GD28907@S2100-06.ap.freescale.net>
References: <1316550244-3655-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1316550244-3655-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 03:24:01PM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> Hopefully, this is the final or near final version of GIC binding support.
> 
> Changes from the previous version:
> - SPIs and PPIs are numbered starting at 0. Now the gic has it's own irq
>   domain translate function instead of the simple domain one.
> - interrupt cell format has changed based on Grant's proposal.
> - Dropped "ARM: gic: allow irq_start to be 0". Instead, the first 16 irqs
>   are skipped and the domain irq_base adjusted accordingly.
> - Added a fix to of_irq_find_parent when the parent == child.
> - Renamed intc_desc.parent to intc_desc.interrupt_parent.
> - Implemented Grant's algorithm for walking the list of interrupt
>   controllers. Added a return value to interrupt init functions, so they
>   don't get added to the parent list on a init failure.
> 
> The changes are significant enough that I did not include previous
> acked/reviewed/tested-by's.
> 
You can add mine back.  On imx6q:

Tested-by: Shawn Guo <shawn.guo@linaro.org>

Hopefully, this is the last round of binding scheme change.  There are
63 nodes in imx6q dts with 'interrupts' property.  I have changed them
3 times :)

-- 
Regards,
Shawn

