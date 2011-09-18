Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab1IRGb1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 02:31:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49872 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab1IRGbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 02:31:21 -0400
Date: Sun, 18 Sep 2011 00:21:44 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Dave Martin <dave.martin@linaro.org>
Cc: "Cousson, Benoit" <b-cousson@ti.com>, Rob Herring <robherring2@gmail.com>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 5/5] ARM: gic: add OF based initialization
Message-ID: <20110918062144.GF3523@ponder.secretlab.ca>
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com>
 <1316017900-19918-6-git-send-email-robherring2@gmail.com>
 <CAJuYYwSFu2HC+u2NY41+yw9tEyy85RKa4Dpm3SL+jbwS_OOA0A@mail.gmail.com>
 <4E71CE5D.9030900@ti.com>
 <20110916160939.GA2100@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110916160939.GA2100@arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 05:09:39PM +0100, Dave Martin wrote:
> For now, we express the mapping by putting an interrupt-map in the
> core-tile DT, but this feels inelegant as well as wasteful -- expressing
> "+ 32" using a table which is about 1K in size and duplicates that
> information 43 times.
> 
> Using a dedicated irq domain or a fake interrupt controller node to
> encapsulate the motherboard interrupts feels like a cleaner approach,
> but for now I'm not clear on the best way to do it.

An irq nexus node would indeed be something to investigate for your
particular case.  Look for examples of interrupt-map.  It is most
often used for handling IRQ swizzling on PCI busses.

g.

