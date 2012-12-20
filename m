Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184Ab2LTSpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 13:45:39 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:50009 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751060Ab2LTSpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 13:45:31 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 50.131.214.131
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX192JEv6GtZmIdVOl95YWWwc
Date: Thu, 20 Dec 2012 10:45:25 -0800
From: Tony Lindgren <tony@atomide.com>
To: Olof Johansson <olof@lixom.net>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        torvalds@linux-foundation.org, arm@kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.ripard@free-electrons.com
Subject: Re: [GIT PULL v2] ARM: arm-soc fixes for 3.8
Message-ID: <20121220184525.GC21056@atomide.com>
References: <20121220163814.GA29557@quad.lixom.net>
 <20121220175639.GA14363@n2100.arm.linux.org.uk>
 <CAOesGMgxXmXUW2RP_5AxJ6Z5sRBhFJ2CQz4S12MwXAb3=ibYOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOesGMgxXmXUW2RP_5AxJ6Z5sRBhFJ2CQz4S12MwXAb3=ibYOA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Olof Johansson <olof@lixom.net> [121220 10:11]:
> 
> Yep, I forgot to bring the fixes branch into our for-next. Try again
> once it mirrors out, I just pushed out a rebuild of it. New top commit
> should be e691d77e8825054376b31e79a9b5f9fa79fe764d.
> 
> I'm doing a "build all defconfigs" run before sending the incremental
> pull request of fixes to Linus.

Commit e691d77e8825054376b31e79a9b5f9fa79fe764d builds and
boots with my testconfigs.

I'm seeing the "BUG: spinlock bad magic on CPU#0" issue
reported and fixed here:

http://marc.info/?l=linux-arm-kernel&m=135594868503683&w=2

But that's probably been already posted as a proper patch
somewhere?

Regards,

Tony
