Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933797Ab1D2UVj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:21:39 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:34790 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932307Ab1D2UVi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:21:38 -0400
Date: Fri, 29 Apr 2011 22:21:36 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Christian Kujau <lists@nerdbynature.de>
Cc: Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com, minchan.kim@gmail.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
Message-ID: <20110429202136.GB13166@x4.trippels.de>
References: <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org>
 <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org>
 <20110427022655.GE12436@dastard>
 <alpine.DEB.2.01.1104270042510.18728@trent.utfs.org>
 <20110427102824.GI12436@dastard>
 <alpine.DEB.2.01.1104281008320.18728@trent.utfs.org>
 <20110428233751.GR12436@dastard>
 <alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
 <20110429201701.GA13166@x4.trippels.de>
 <alpine.DEB.2.01.1104291319270.18728@trent.utfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.01.1104291319270.18728@trent.utfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.04.29 at 13:20 -0700, Christian Kujau wrote:
> On Fri, 29 Apr 2011 at 22:17, Markus Trippelsdorf wrote:
> > I could be the hrtimer bug again. Would you try to reproduce the issue
> > with this patch applied?
> > http://git.us.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;h=ce31332d3c77532d6ea97ddcb475a2b02dd358b4
> 
> will do. Should I enable TREE_RCU again (SMP) or use TINY_RCU for my UP 
> system?

It shouldn't matter. Both will do.
-- 
Markus
