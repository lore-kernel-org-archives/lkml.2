Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753984Ab2GWHr7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 03:47:59 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:22860 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753926Ab2GWHr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 03:47:58 -0400
Date: Mon, 23 Jul 2012 09:47:45 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Zhang Rui <rui.zhang@intel.com>
Cc: Devendra Naga <develkernel412222@gmail.com>,
        Len Brown <len.brown@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        Fengguang Wu <wfg@linux.intel.com>,
        Durgadoss R <durgadoss.r@intel.com>
Subject: Re: [PATCH] thermal: fix build error at thermal_sys.c
Message-ID: <20120723094745.598514ed@endymion.delvare>
In-Reply-To: <1343028487.1682.316.camel@rui.sh.intel.com>
References: <1342944622-16263-1-git-send-email-develkernel412222@gmail.com>
	<20120722125810.052ca19e@endymion.delvare>
	<1343008936.1682.307.camel@rui.sh.intel.com>
	<20120723085413.38b5a314@endymion.delvare>
	<1343028487.1682.316.camel@rui.sh.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Jul 2012 15:28:07 +0800, Zhang Rui wrote:
> so "my tree is set for linux-next inclusion" means that, all the stuff
> will be merged in linux-next automatically, even if I have not asked
> linux-next to pull my changes, right?

Yes, exactly. You never have to ask "linux-next to pull your changes",
it is an automatic daily event. If you think some patches aren't ready
to go to linux-next then put them in a different branch of your tree.

-- 
Jean Delvare
