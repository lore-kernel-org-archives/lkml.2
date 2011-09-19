Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755645Ab1ISNdo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 09:33:44 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:46195 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753272Ab1ISNdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 09:33:43 -0400
Date: Mon, 19 Sep 2011 14:33:01 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Cousson, Benoit" <b-cousson@ti.com>
Cc: Rob Herring <robherring2@gmail.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/5] ARM: gic: add OF based initialization
Message-ID: <20110919133301.GR16381@n2100.arm.linux.org.uk>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com> <1316017900-19918-6-git-send-email-robherring2@gmail.com> <CAJuYYwSFu2HC+u2NY41+yw9tEyy85RKa4Dpm3SL+jbwS_OOA0A@mail.gmail.com> <4E71CE5D.9030900@ti.com> <4E71F978.6020402@gmail.com> <4E72030F.1090300@ti.com> <4E722B2D.4050307@gmail.com> <4E770FA6.2070305@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E770FA6.2070305@ti.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 11:47:18AM +0200, Cousson, Benoit wrote:
> Since the cpumask is not relevant for the SPI, maybe having two  
> interrupt controllers will be more relevant. Or maybe 3, since there is  
> some SGIs as well.

I don't think anyone uses SGIs outside of the common SMP code.
Therefore they're handled entirely separately for the root GIC.

(If there's two GICs - some platforms do have two - then the SGIs on
the non-root GIC are unused.)
