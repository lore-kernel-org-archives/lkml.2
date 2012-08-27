Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab2H0Sgr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 14:36:47 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:36650 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971Ab2H0Sgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 14:36:45 -0400
Date: Mon, 27 Aug 2012 18:36:45 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: "Hiremath, Vaibhav" <hvaibhav@ti.com>
cc: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tony Lindgren <tony@atomide.com>, "Cousson, Benoit" <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <robherring2@gmail.com>
Subject: RE: [PATCH] ARM: AM33XX: clock: Add dcan clock aliases for
 device-tree
In-Reply-To: <79CD15C6BA57404B839C016229A409A83EA99396@DBDE01.ent.ti.com>
Message-ID: <alpine.DEB.2.00.1208271836270.26953@utopia.booyaka.com>
References: <1346061842-28714-1-git-send-email-hvaibhav@ti.com> <alpine.DEB.2.00.1208271717420.26953@utopia.booyaka.com> <79CD15C6BA57404B839C016229A409A83EA99396@DBDE01.ent.ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Aug 2012, Hiremath, Vaibhav wrote:

> On Mon, Aug 27, 2012 at 22:50:12, Paul Walmsley wrote:
>
> > Is the dcan driver present in v3.6-rc kernels?  
> 
> Multiple versions have been submitted already, I have validated using them.
> Irrespective of this, it is independent change and required for the driver.

OK, will queue it for 3.7.

- Paul
