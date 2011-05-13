Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758581Ab1EMTFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 15:05:47 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:2413 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964Ab1EMTFq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 15:05:46 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Fri, 13 May 2011 12:03:41 -0700
Subject: Re: [PATCH v2] net: rfkill: add generic gpio rfkill driver
From: Rhyland Klein <rklein@nvidia.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "olof@lixom.net" <olof@lixom.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1305270943.3487.5.camel@jlt3.sipsolutions.net>
References: <1305159661-11982-1-git-send-email-rklein@nvidia.com>
	 <1305189092.3461.10.camel@jlt3.sipsolutions.net>
	 <1305224592.10961.10.camel@rklein-linux2>
	 <1305225648.3461.37.camel@jlt3.sipsolutions.net>
	 <1305226377.10961.12.camel@rklein-linux2>
	 <1305226969.3461.38.camel@jlt3.sipsolutions.net>
	 <1305235386.10961.13.camel@rklein-linux2>
	 <1305270943.3487.5.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 13 May 2011 12:02:54 -0700
Message-ID: <1305313374.10961.23.camel@rklein-linux2>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-05-13 at 00:15 -0700, Johannes Berg wrote:
> On Thu, 2011-05-12 at 14:23 -0700, Rhyland Klein wrote:
> > On Thu, 2011-05-12 at 12:02 -0700, Johannes Berg wrote:
> > > On Thu, 2011-05-12 at 11:52 -0700, Rhyland Klein wrote:
> > > 
> > > > > If, on the other hand, rfkill decides that at the time of loading the
> > > > > driver wifi should be on, then the first change would be +1 and it'll
> > > > > flip between 0 and +1.
> > > > > 
> > > > > This seems like it'll cause issues at some point, so I think you should
> > > > > either allow the driver to set the initial state or hardcode one of
> > > > > these possibilities (so at least it's predictable)
> > > 
> > > > I won't go negative, if you look, it only will disable clock if it knows
> > > > it has already enabled it. 
> > > 
> > > Ah, you're right, I misread the macros.
> 
> > So the patch is good as is?
> 
> I think so, yes.
> 
> johannes
> 

John, Johannes suggested you are able to pull in this patch?

rhyland

