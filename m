Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab1ADUUN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 15:20:13 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:40693 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750866Ab1ADUUL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 15:20:11 -0500
Date: Tue, 4 Jan 2011 12:19:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Tony Lindgren <tony@atomide.com>, Greg KH <greg@kroah.com>,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Benoit Cousson <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Hari Kanigeri <h-kanigeri2@ti.com>, Suman Anna <s-anna@ti.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 0/4] Introduce hardware spinlock framework
Message-Id: <20110104121921.3550dcfa.akpm@linux-foundation.org>
In-Reply-To: <AANLkTikLuu+njQA_PRmS_q8zs_xpB2gsqh3oZQJkB_Cm@mail.gmail.com>
References: <1291420247-18171-1-git-send-email-ohad@wizery.com>
	<AANLkTin1fd=Kei7Fo6G+uR+270HdTkc71fvsA6qjBjcA@mail.gmail.com>
	<20101214170656.GA3832@kroah.com>
	<AANLkTi=q=QMQ_Abxb8eUWT_qGG8K=pc892ZB-mqgt_mh@mail.gmail.com>
	<20101216210837.GA22895@kroah.com>
	<AANLkTi=s_Urcin4SAp1mXrKmoyzR2=6YuS3aU+OYYgqK@mail.gmail.com>
	<20101218005311.GE5941@atomide.com>
	<AANLkTikLuu+njQA_PRmS_q8zs_xpB2gsqh3oZQJkB_Cm@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Jan 2011 14:23:20 +0200
Ohad Ben-Cohen <ohad@wizery.com> wrote:

> Hi Andrew,
> 
> On Sat, Dec 18, 2010 at 2:53 AM, Tony Lindgren <tony@atomide.com> wrote:
> > * Ohad Ben-Cohen <ohad@wizery.com> [101216 13:34]:
> >> Tony, Andrew, can you please have a look ?
> >>
> >> Any comment or suggestion is appreciated.
> >
> > Looks sane to me from omap point of view and it seems the locks
> > are now all timeout based:
> >
> > Acked-by: Tony Lindgren <tony@atomide.com>
> 
> Can you please have a look at this patch set (see link no. [1] below) ?

I looked - it looks reasonable.  This is exactly the wrong time to be
looking at large new patchsets - please refresh, retest and resend
after -rc1 is released?

