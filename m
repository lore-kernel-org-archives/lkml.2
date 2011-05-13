Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598Ab1EMTbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 15:31:00 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37031 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932807Ab1EMTa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 15:30:56 -0400
Date: Fri, 13 May 2011 15:20:20 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: "olof@lixom.net" <olof@lixom.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] net: rfkill: add generic gpio rfkill driver
Message-ID: <20110513192019.GC10555@tuxdriver.com>
References: <1305159661-11982-1-git-send-email-rklein@nvidia.com>
 <1305189092.3461.10.camel@jlt3.sipsolutions.net>
 <1305224592.10961.10.camel@rklein-linux2>
 <1305225648.3461.37.camel@jlt3.sipsolutions.net>
 <1305226377.10961.12.camel@rklein-linux2>
 <1305226969.3461.38.camel@jlt3.sipsolutions.net>
 <1305235386.10961.13.camel@rklein-linux2>
 <1305270943.3487.5.camel@jlt3.sipsolutions.net>
 <1305313374.10961.23.camel@rklein-linux2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305313374.10961.23.camel@rklein-linux2>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 12:02:54PM -0700, Rhyland Klein wrote:
> On Fri, 2011-05-13 at 00:15 -0700, Johannes Berg wrote:
> > On Thu, 2011-05-12 at 14:23 -0700, Rhyland Klein wrote:
> > > On Thu, 2011-05-12 at 12:02 -0700, Johannes Berg wrote:
> > > > On Thu, 2011-05-12 at 11:52 -0700, Rhyland Klein wrote:
> > > > 
> > > > > > If, on the other hand, rfkill decides that at the time of loading the
> > > > > > driver wifi should be on, then the first change would be +1 and it'll
> > > > > > flip between 0 and +1.
> > > > > > 
> > > > > > This seems like it'll cause issues at some point, so I think you should
> > > > > > either allow the driver to set the initial state or hardcode one of
> > > > > > these possibilities (so at least it's predictable)
> > > > 
> > > > > I won't go negative, if you look, it only will disable clock if it knows
> > > > > it has already enabled it. 
> > > > 
> > > > Ah, you're right, I misread the macros.
> > 
> > > So the patch is good as is?
> > 
> > I think so, yes.
> > 
> > johannes
> > 
> 
> John, Johannes suggested you are able to pull in this patch?

I've got it, thanks.

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
