Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753369Ab2IWCBi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 22:01:38 -0400
Received: from utopia.booyaka.com ([74.50.51.50]:36522 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752456Ab2IWCBg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 22:01:36 -0400
Date: Sun, 23 Sep 2012 02:01:35 +0000 (UTC)
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
In-Reply-To: <20120923015645.GJ2934@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1209230159100.28806@utopia.booyaka.com>
References: <20120920232114.GO2449@linux.vnet.ibm.com> <alpine.DEB.2.00.1209211803290.8839@utopia.booyaka.com> <20120921185827.GC2454@linux.vnet.ibm.com> <alpine.DEB.2.00.1209211900520.8839@utopia.booyaka.com> <20120921195717.GD2454@linux.vnet.ibm.com>
 <alpine.DEB.2.00.1209221836070.10663@utopia.booyaka.com> <20120922201043.GE2934@linux.vnet.ibm.com> <20120922215923.GA13161@linux.vnet.ibm.com> <alpine.DEB.2.00.1209222223080.22590@utopia.booyaka.com> <alpine.DEB.2.00.1209230136320.28806@utopia.booyaka.com>
 <20120923015645.GJ2934@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 22 Sep 2012, Paul E. McKenney wrote:

> Very cool, thank you for your testing efforts!!!

You're welcome.

> May I apply your Tested-by to this patch?

Please do:

Tested-by: Paul Walmsley <paul@pwsan.com>  # OMAP4430

Am testing on OMAP3730 (single-core) now.


- Paul
