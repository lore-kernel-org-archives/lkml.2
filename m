Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932085Ab1I2JWD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 05:22:03 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41817 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753567Ab1I2JWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 05:22:01 -0400
Date: Thu, 29 Sep 2011 10:21:49 +0100
From: Jamie Iles <jamie@jamieiles.com>
To: Rob Herring <robherring2@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        marc.zyngier@arm.com, thomas.abraham@linaro.org, jamie@jamieiles.com,
        b-cousson@ti.com, shawn.guo@linaro.org,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 0/2] GIC OF bindings
Message-ID: <20110929092149.GL17204@pulham.picochip.com>
References: <1317268436-1613-1-git-send-email-robherring2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317268436-1613-1-git-send-email-robherring2@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 10:53:54PM -0500, Rob Herring wrote:
> From: Rob Herring <rob.herring@calxeda.com>
> 
> With recent patches for VIC device tree support and GIC MULTI_IRQ support,
> it is evident that the irq domain support should be moved into the core GIC
> code and not be dependent on the DT initialization. So I've split things up
> into 2 patches separating irq_domain and device-tree code.
> 
> This should only change the internals of the GIC code. The binding is
> unchanged from the previous version. Yeah!
> 
> The full series is available here. This includes Russell's devel-stable and
> for-next branches and Nico's vmalloc branch.

Looks good to me!

Reviewed-by: Jamie Iles <jamie@jamieiles.com>
