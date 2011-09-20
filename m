Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751300Ab1ITE0I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Sep 2011 00:26:08 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:60484 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab1ITE0G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Sep 2011 00:26:06 -0400
Date: Mon, 19 Sep 2011 22:18:04 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Rob Herring <robherring2@gmail.com>
Cc: "Cousson, Benoit" <b-cousson@ti.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "marc.zyngier@arm.com" <marc.zyngier@arm.com>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 5/5] ARM: gic: add OF based initialization
Message-ID: <20110920041804.GD30517@ponder.secretlab.ca>
References: <CAJuYYwSFu2HC+u2NY41+yw9tEyy85RKa4Dpm3SL+jbwS_OOA0A@mail.gmail.com>
 <4E71CE5D.9030900@ti.com>
 <4E71F978.6020402@gmail.com>
 <4E72030F.1090300@ti.com>
 <4E722B2D.4050307@gmail.com>
 <4E76615C.3000005@gmail.com>
 <4E77310A.3000106@ti.com>
 <4E774847.3020104@gmail.com>
 <CACxGe6v9nd5f5x-eu9hUyAqdS1+p3h6ixyutECYLdNo3ewDH0w@mail.gmail.com>
 <4E77B9E3.40004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E77B9E3.40004@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 19, 2011 at 04:53:39PM -0500, Rob Herring wrote:
> On 09/19/2011 04:14 PM, Grant Likely wrote:
> > (Alternately, if there is no need for a CPU mask because PPI
> > interrupts will never be wired to more than one CPU, then it would be
> > better to encode the CPU number into the second cell with the SPI
> > number).
> You meant PPI number, right?                                    ^^^

Yes, I meant PPI number.  I keep transposing the two; I don't know why.

> The common case at least on the A9 is a PPI is routed to all cores. QC
> is different though. This was discussed previously. Basically, anything
> is possible here, so the mask is needed for sure.

Okay.

g.
