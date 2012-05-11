Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946058Ab2EKTWI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2012 15:22:08 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:2896 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760812Ab2EKTWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2012 15:22:05 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 11 May 2012 12:22:02 -0700
Subject: Re: [PATCH 0/6 v3] Update TPS65910 to boot using devicetree
From: Rhyland Klein <rklein@nvidia.com>
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, "Liam Girdwood" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
In-Reply-To: <20120511093842.GC1214@sortiz-mobl>
References: <1336502563-31789-1-git-send-email-rklein@nvidia.com>
	 <20120511093842.GC1214@sortiz-mobl>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 May 2012 12:21:58 -0700
Message-ID: <1336764118.3085.0.camel@rhyland-vbox>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-11 at 02:38 -0700, Samuel Ortiz wrote:
> Hi Rhyland,
> 
> On Tue, May 08, 2012 at 11:42:37AM -0700, Rhyland Klein wrote:
> > This patch set updates the tps65910 driver to boot using devicetree.
> > 
> > This patch set now uses the new addition to the of_regulator code,
> > of_regulator_match to find all the regulator init data for the device.
> > 
> > Rhyland Klein (6):
> >   mfd: tps65910: Commonize regmap access through header
> >   regulator: tps65910: Add device tree bindings
> >   mfd: tps65910: Add device-tree support
> >   regulator: tps65910 regulator: add device tree support
> >   mfd: tps65910-irq: Add devicetree init support
> >   ARM: Tegra: Add support for TPS65910 PMIC
> I applied patches 1,2 and 3 to my for-next branch.
> Patch 4 is a regulator one, I assume Mark is going to take it. And patch 5
> needs some additional work.
> 
> Cheers,
> Samuel.
> 
Thank! I will resend the change for patch 5.

-rhyland

-- 
nvpublic

