Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753904Ab2LQVDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 16:03:41 -0500
Received: from utopia.booyaka.com ([74.50.51.50]:39462 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab2LQVDk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 16:03:40 -0500
Date: Mon, 17 Dec 2012 21:03:39 +0000 (UTC)
From: Paul Walmsley <paul@pwsan.com>
To: Benoit Cousson <b-cousson@ti.com>
cc: Roger Quadros <rogerq@ti.com>, Tony Lindgren <tony@atomide.com>,
        balbi@ti.com, sameo@linux.intel.com, keshava_mgowda@ti.com,
        sshtylyov@mvista.com, bjorn@mork.no, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, Rajendra Nayak <rnayak@ti.com>,
        Mike Turquette <mturquette@gmail.com>
Subject: Re: [PATCH v4 16/23] ARM: OMAP2+: clock data: Merge utmi_px_gfclk
 into usb_host_hs_utmi_px_clk
In-Reply-To: <50CF47FF.2010002@ti.com>
Message-ID: <alpine.DEB.2.00.1212172102010.29833@utopia.booyaka.com>
References: <1355134833-5199-1-git-send-email-rogerq@ti.com> <1355134833-5199-17-git-send-email-rogerq@ti.com> <20121214182855.GB4989@atomide.com> <alpine.DEB.2.00.1212141838130.5915@utopia.booyaka.com> <50CED412.7060407@ti.com> <50CF449F.7090708@ti.com>
 <50CF47FF.2010002@ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012, Benoit Cousson wrote:

> It was done for legacy reason but should disappear once the modulemode
> will be be removed from the clock nodes.

Here's a start at taking care of the low-hanging fruit:

http://marc.info/?l=linux-omap&m=135577685007813&w=2

Only lightly tested, so tests with Kconfigs with lots of OMAP drivers 
enabled would be appreciated.


- Paul
