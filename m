Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab2ALX5Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 18:57:16 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:60132 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756173Ab2ALX5L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 18:57:11 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kukjin Kim <kgene.kim@samsung.com>
Subject: Re: Build error at drivers/base/power/domain_governor.c when PM_RUNTIME is not set
Date: Fri, 13 Jan 2012 01:00:36 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.0+; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, "'Linus'" <torvalds@linux-foundation.org>,
        linux-samsung-soc@vger.kernel.org
References: <018a01ccce67$a6eee850$f4ccb8f0$%kim@samsung.com> <201201092314.20561.rjw@sisk.pl> <02b301ccd0ff$02b8dfd0$082a9f70$%kim@samsung.com>
In-Reply-To: <02b301ccd0ff$02b8dfd0$082a9f70$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201130100.37008.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 12, 2012, Kukjin Kim wrote:
> Rafael J. Wysocki wrote:
> > 
> > On Monday, January 09, 2012, Kukjin Kim wrote:
> > > Hi Rafael,
> > >
> > > This is just reporting of build error.
> > >
> > > Current mainline happens build error at
> > drivers/base/power/domain_governor.c
> > > file like following when CONFIG_PM_RUNTIME is not set. For example, it
> > > happens with s3c6400_defconfig now.
> > >
> > > drivers/base/power/domain_governor.c: In function 'default_stop_ok':
> > > drivers/base/power/domain_governor.c:25: error: 'struct dev_pm_info' has
> > no
> > > member named 'max_time_suspended_ns'
> > > drivers/base/power/domain_governor.c:29: error: 'struct dev_pm_info' has
> > no
> > > member named 'max_time_suspended_ns'
> > > drivers/base/power/domain_governor.c: In function
> > 'default_power_down_ok':
> > > drivers/base/power/domain_governor.c:94: error: 'struct dev_pm_info' has
> > no
> > > member named 'max_time_suspended_ns'
> > > drivers/base/power/domain_governor.c:98: error: 'struct dev_pm_info' has
> > no
> > > member named 'max_time_suspended_ns'
> > > drivers/base/power/domain_governor.c:100: error: 'struct dev_pm_info'
> > has no
> > > member named 'suspend_time'
> > 
> > The appended patch fixes the problem for me, can you please test it?
> > 
> Hi Rafael,
> 
> Looks ok to me :)

Cool, thanks!

Rafael
