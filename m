Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab2EWFoi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 01:44:38 -0400
Received: from ns1.pc-advies.be ([83.149.101.17]:53495 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752268Ab2EWFog (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 01:44:36 -0400
Date: Wed, 23 May 2012 07:44:30 +0200
From: Wim Van Sebroeck <wim@iguana.be>
To: Guenter Roeck <guenter@roeck-us.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Aaron Sierra <asierra@xes-inc.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-watchdog@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: linux-next: manual merge of the watchdog tree with the mfd tree
Message-ID: <20120523054430.GH3074@spo001.leaseweb.com>
References: <20120518152348.1e5070cdc16cfdf00682546d@canb.auug.org.au> <20120518083234.GW3074@spo001.leaseweb.com> <6.2.5.6.2.20120518181141.028c8090@roeck-us.net> <20120522163559.GD3074@spo001.leaseweb.com> <6.2.5.6.2.20120522153050.0284ee38@roeck-us.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6.2.5.6.2.20120522153050.0284ee38@roeck-us.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

Since %04llx with a typecast to u64 is the way to go (Thanks Stephen and Randy)...

> How do we make sure that Randy's patch makes it upstream ? The iTCO 
> patch is currently in Sam's tree.

Can you carry Randy's patch/fix (since it fixes the change introduced by the iTCO_wdt mfd patch)?
If not then I will apply the patch later on once the iTCO_wdt mfd patch is mainstream.

Kind regards,
Wim.

