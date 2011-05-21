Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1EUIl5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 04:41:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:17944 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab1EUIly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 04:41:54 -0400
Message-Id: <013811$4lfs6@fmsmga002.fm.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,246,1304319600"; 
   d="scan'208";a="4898694"
Date: Sat, 21 May 2011 09:41:45 +0100
To: Ray Lee <ray-lk@madrabbit.org>, Luke-Jr <luke@dashjr.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: Major 2.6.38 regression ignored?
Cc: intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        LKML <linux-kernel@vger.kernel.org>
References: <201105201306.31204.luke@dashjr.org> <BANLkTimOqhNEsBEg6f=nMiMJqYGNyFJmeQ@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <BANLkTimOqhNEsBEg6f=nMiMJqYGNyFJmeQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 20 May 2011 11:08:56 -0700, Ray Lee <ray-lk@madrabbit.org> wrote:
> [ Adding Chris Wilson (author of the problematic patch) and Rafael Wysocki
> to the message ]
> 
> On Fri, May 20, 2011 at 10:06 AM, Luke-Jr <luke@dashjr.org> wrote:
> 
> > I submitted https://bugzilla.kernel.org/show_bug.cgi?id=33662 a month ago
> > against 2.6.38. Now 2.6.39 was just released without the regression being
> > addressed. This bug makes the system unusable... Some guys on IRC suggested
> > I
> > email, so here it is.
> >
> 
> See the bugzilla entry for the bisection history.

Which has nothing to do with Luke's bug. Considering the thousand things
that can go wrong during X starting, without a hint as to which it is nigh
on impossible to debug except by trial and error. If you set up
netconsole, does the kernel emit an OOPS with it's last dying breath?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
