Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab2IWHzx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Sep 2012 03:55:53 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:36730 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2IWHzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Sep 2012 03:55:51 -0400
Date: Sun, 23 Sep 2012 07:55:50 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: "Bruce, Becky" <bbruce@ti.com>,
        "Paul E. McKenney" <paul.mckenney@linaro.org>,
        "<linux-kernel@vger.kernel.org>" <linux-kernel@vger.kernel.org>,
        "<linux-omap@vger.kernel.org>" <linux-omap@vger.kernel.org>,
        "<linux-arm-kernel@lists.infradead.org>" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hilman, Kevin" <khilman@ti.com>,
        "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "Hunter, Jon" <jon-hunter@ti.com>,
        "<snijsure@grid-net.com>" <snijsure@grid-net.com>, fweisbec@gmail.com
Subject: Re: rcu self-detected stall messages on OMAP3, 4 boards
In-Reply-To: <20120922231121.GH2934@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1209230753120.7868@utopia.booyaka.com>
References: <alpine.DEB.2.00.1209202244470.32589@utopia.booyaka.com> <20120920232114.GO2449@linux.vnet.ibm.com> <alpine.DEB.2.00.1209211803290.8839@utopia.booyaka.com> <20120921185827.GC2454@linux.vnet.ibm.com> <alpine.DEB.2.00.1209211900520.8839@utopia.booyaka.com>
 <20120921195717.GD2454@linux.vnet.ibm.com> <alpine.DEB.2.00.1209221836070.10663@utopia.booyaka.com> <20120922201043.GE2934@linux.vnet.ibm.com> <20120922215923.GA13161@linux.vnet.ibm.com> <alpine.DEB.2.00.1209222223080.22590@utopia.booyaka.com>
 <20120922231121.GH2934@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2012, Paul E. McKenney wrote:

> On Sat, Sep 22, 2012 at 10:25:59PM +0000, Paul Walmsley wrote:
> 
> > The recent tests here have been on Pandaboard, which is dual-CPU, but my 
> > recollection is that I also observed the warnings on a single-core 
> > Beagleboard.  Will re-test.
> 
> Anxiously awaiting the results.

The same problem exists on BeagleBoard XM (OMAP3730, single-core 
Cortex-A8):

   http://www.pwsan.com/omap/transcripts/20120922-beaglexm-rcu-stall-debug-pre-fix.txt

and the same patch fixes it:

   http://www.pwsan.com/omap/transcripts/20120922-beaglexm-rcu-stall-debug-post-fix.txt

Please feel free to update my Tested-by:, if you wish.

Tested-by: Paul Walmsley <paul@pwsan.com>  # OMAP3730, OMAP4430


- Paul
