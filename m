Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933960Ab1FWUY0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:24:26 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:58071 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933860Ab1FWUYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:24:24 -0400
Date: Thu, 23 Jun 2011 22:24:36 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Cong Wang <amwang@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, netdev@vger.kernel.org,
        Chris Ball <cjb@laptop.org>, Len Brown <len.brown@intel.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Philip Rakity <prakity@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Josh Triplett <josh@joshtriplett.org>, linux-mmc@vger.kernel.org,
        linux-pm@lists.linux-foundation.org
Subject: Re: [PATCH 4/5] pm: move pm notifiers into suspend.h
Message-ID: <20110623202436.GB8514@elf.ucw.cz>
References: <1308724522-32461-1-git-send-email-amwang@redhat.com>
 <1308724522-32461-5-git-send-email-amwang@redhat.com>
 <201106222149.28252.rjw@sisk.pl>
 <4E02C93A.7010601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E02C93A.7010601@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2011-06-23 13:03:54, Cong Wang wrote:
> ??? 2011???06???23??? 03:49, Rafael J. Wysocki ??????:
> >>+#ifdef CONFIG_PM
> >>>  +#include<linux/suspend.h>
> >>>  +#endif
> >I don't think the #ifdef in necessary.  Any dependencies on CONFIG_PM
> >(or CONFIG_SUSPEND etc.) should be taken care of inside of suspend.h.
> >This file should be fixed if they aren't.
> >
> 
> Ok, please check the updated version below.
> 
> Thanks.
> 

> Author: Amerigo Wang <amwang@redhat.com>
> 
>     pm: move pm notifiers into suspend.h
> 
> Signed-off-by: WANG Cong <amwang@redhat.com>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
