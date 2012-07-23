Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753448Ab2GWGye (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 02:54:34 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:42402 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab2GWGyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 02:54:33 -0400
Date: Mon, 23 Jul 2012 08:54:13 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Devendra Naga <develkernel412222@gmail.com>,
        Len Brown <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Fengguang Wu <wfg@linux.intel.com>,
        Durgadoss R <durgadoss.r@intel.com>
Subject: Re: [PATCH] thermal: fix build error at thermal_sys.c
Message-ID: <20120723085413.38b5a314@endymion.delvare>
In-Reply-To: <1343008936.1682.307.camel@rui.sh.intel.com>
References: <1342944622-16263-1-git-send-email-develkernel412222@gmail.com>
	<20120722125810.052ca19e@endymion.delvare>
	<1343008936.1682.307.camel@rui.sh.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rui,

On Mon, 23 Jul 2012 10:02:16 +0800, Zhang Rui wrote:
> BTW: what is the rule for linux-next?
> I refreshed the patches, did some test, and sent to mailing list
> saying that I want to push them to linux-next, please review.
> And then I got bug report from linux-next...
> shouldn't them be merged after I sending git pull request?

Your tree is set for linux-next inclusion. This means that, every day,
the current state of (one branch of) your tree makes it into that day's
linux-next. linux-next receives some testing so you may receive bug
reports that way (most frequently merge and build issues.)

But patches don't go from linux-next to Linus's upstream tree
automatically. Whenever you want your patches to actually go to Linus,
you must ask Linus explicitly to pull them.

So, when a build issue is found in linux-next, the right thing to do is
to blast the faulty branch and recreate it without the build breakage,
then have it go in at least one linux-next iterations to make sure you
did get things right this time, and only then ask Linus to pull from
your branch.

-- 
Jean Delvare
