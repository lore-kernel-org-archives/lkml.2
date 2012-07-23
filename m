Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753951Ab2GWH0u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 03:26:50 -0400
Received: from mga14.intel.com ([143.182.124.37]:45819 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab2GWH0t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 03:26:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="125673540"
Message-ID: <1343028487.1682.316.camel@rui.sh.intel.com>
Subject: Re: [PATCH] thermal: fix build error at thermal_sys.c
From: Zhang Rui <rui.zhang@intel.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Devendra Naga <develkernel412222@gmail.com>,
        Len Brown <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Fengguang Wu <wfg@linux.intel.com>,
        Durgadoss R <durgadoss.r@intel.com>
Date: Mon, 23 Jul 2012 15:28:07 +0800
In-Reply-To: <20120723085413.38b5a314@endymion.delvare>
References: <1342944622-16263-1-git-send-email-develkernel412222@gmail.com>
	 <20120722125810.052ca19e@endymion.delvare>
	 <1343008936.1682.307.camel@rui.sh.intel.com>
	 <20120723085413.38b5a314@endymion.delvare>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 一, 2012-07-23 at 08:54 +0200, Jean Delvare wrote:
> Hi Rui,
> 
> On Mon, 23 Jul 2012 10:02:16 +0800, Zhang Rui wrote:
> > BTW: what is the rule for linux-next?
> > I refreshed the patches, did some test, and sent to mailing list
> > saying that I want to push them to linux-next, please review.
> > And then I got bug report from linux-next...
> > shouldn't them be merged after I sending git pull request?
> 
> Your tree is set for linux-next inclusion.
>  This means that, every day,
> the current state of (one branch of) your tree makes it into that day's
> linux-next. linux-next receives some testing so you may receive bug
> reports that way (most frequently merge and build issues.)
> 
> But patches don't go from linux-next to Linus's upstream tree
> automatically. Whenever you want your patches to actually go to Linus,
> you must ask Linus explicitly to pull them.
> 
> So, when a build issue is found in linux-next, the right thing to do is
> to blast the faulty branch and recreate it without the build breakage,
> then have it go in at least one linux-next iterations to make sure you
> did get things right this time, and only then ask Linus to pull from
> your branch.
> 
I know they should stay in linux-next for a while before asking Linus to
pull them, but I did not expect them to go into linux-next immediately
when I submitted all the patches into my next branch and sent out for
review.

so "my tree is set for linux-next inclusion" means that, all the stuff
will be merged in linux-next automatically, even if I have not asked
linux-next to pull my changes, right?

sorry for the mistake again.

thanks,
rui



