Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933472Ab2GFDHH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 23:07:07 -0400
Received: from mga11.intel.com ([192.55.52.93]:37758 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932465Ab2GFDHF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 23:07:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="173982365"
Date: Fri, 6 Jul 2012 11:07:01 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: automated warning notifications
Message-ID: <20120706030701.GB6848@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120615014835.GA5695@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Fri, Jun 15, 2012 at 09:48:35AM +0800, Fengguang Wu wrote:
> > Hi Dan,
> > 
> > On Thu, Jun 14, 2012 at 08:25:23PM +0300, Dan Carpenter wrote:
> > > Hi Fengguang,
> > > 
> > > I also check new static checker warnings and sometimes email people.
> > 
> > That would be nice!
> > 
> > > I wonder if we are duplicating each others work.  For example, did
> > > you send an email asking about the following Sparse warning:
> > > 
> > > sound/soc/codecs/ab8500-codec.c:1959:53: warning: cast truncates bits from constant value (1013 becomes 13)
> > 
> > I did try sending out sparse warnings to people, some time ago...
> 
> Apparently you have started up again?  We're starting to trod on
> each other's toes and people are getting annoyed with me because I
> am reporting them after you...  :/

Sorry for that!  Yeah I restarted the sparse checks and have been
sending out private emails after basic sanity check. Although there
are 10000 existing sparse warnings, there are only very few *new*
sparse warnings per day. This is pretty acceptable.

> Randy has suggested that we send these automated messages to
> kernel-janitors.  I don't know how the other people on kernel
> janitors feel about this but I would be fine with it.

Randy also suggested kernel-janitors. So let's try it. I'll CC
kernel-janitors for all of my error/warning reports and let's check
how well it works.

Thanks,
Fengguang
