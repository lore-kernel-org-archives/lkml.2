Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968291Ab2ESB0y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 21:26:54 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59599 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759894Ab2ESB0w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 21:26:52 -0400
X-Originating-IP: 99.61.165.181
Message-Id: <6.2.5.6.2.20120518181141.028c8090@roeck-us.net>
X-Mailer: QUALCOMM Windows Eudora Version 6.2.5.6
Date: Fri, 18 May 2012 18:20:01 -0700
To: Wim Van Sebroeck <wim@iguana.be>, Stephen Rothwell <sfr@canb.auug.org.au>
From: Guenter Roeck <guenter@roeck-us.net>
Subject: Re: linux-next: manual merge of the watchdog tree with the mfd
  tree
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Aaron Sierra <asierra@xes-inc.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-watchdog@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>
In-Reply-To: <20120518083234.GW3074@spo001.leaseweb.com>
References: <20120518152348.1e5070cdc16cfdf00682546d@canb.auug.org.au>
 <20120518083234.GW3074@spo001.leaseweb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 01:32 AM 5/18/2012, Wim Van Sebroeck wrote:
>Hi Stephen,
>
> > Today's linux-next merge of the watchdog tree got a conflict in
> > drivers/watchdog/iTCO_wdt.c between commit 887c8ec7219f ("watchdog:
> > Convert iTCO_wdt driver to mfd model") from the  tree and commit
> > c3614aa19d3e ("watchdog: iTCO_wdt.c: fix printk format warnings") from
> > the watchdog tree.
> >
> > I fixed it up (see below) and can carry the fix as necessary.
>
>Thanks for fixing this up.
>
>But I'm a bit surprised: I wasn't Cc'ed about this patch to Convert
>the iTCO_wdt driver to the mfd model...
Oh my. Kind of embarrassing to forget one of the maintainers in all 
the discussions which tree this patch set should go through. Even 
though I didn't much of the code, my sign-off is there, and I should 
have made sure that you are on the Cc: list. Sorry for that, and I 
owe you a beer or two if we ever meet in person.

Hope you are ok with the changes - the patch set already missed the 
last commit window because of the which-tree-to-use issue, and it 
would be sad to miss another one. And Jean is really waiting for it 
to go in to be able to push some related patches which need the gpio driver.

Thanks,
Guenter

