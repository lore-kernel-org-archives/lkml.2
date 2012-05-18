Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933339Ab2ERIcm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 04:32:42 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:46662 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1761613Ab2ERIch (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 04:32:37 -0400
Date: Fri, 18 May 2012 10:32:34 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Sierra <asierra@xes-inc.com>, Guenter Roeck <linux@roeck-us.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-watchdog@vger.kernel.org
Subject: Re: linux-next: manual merge of the watchdog tree with the mfd tree
Message-ID: <20120518083234.GW3074@spo001.leaseweb.com>
References: <20120518152348.1e5070cdc16cfdf00682546d@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518152348.1e5070cdc16cfdf00682546d@canb.auug.org.au>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

> Today's linux-next merge of the watchdog tree got a conflict in
> drivers/watchdog/iTCO_wdt.c between commit 887c8ec7219f ("watchdog:
> Convert iTCO_wdt driver to mfd model") from the  tree and commit
> c3614aa19d3e ("watchdog: iTCO_wdt.c: fix printk format warnings") from
> the watchdog tree.
> 
> I fixed it up (see below) and can carry the fix as necessary.

Thanks for fixing this up.

But I'm a bit surprised: I wasn't Cc'ed about this patch to Convert
the iTCO_wdt driver to the mfd model...

Kind regards,
Wim.

