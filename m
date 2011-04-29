Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788Ab1D2UU3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 16:20:29 -0400
Received: from trent.utfs.org ([194.246.123.103]:54270 "EHLO trent.utfs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932307Ab1D2UU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 16:20:28 -0400
Date: Fri, 29 Apr 2011 13:20:25 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
cc: Dave Chinner <david@fromorbit.com>, LKML <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com, minchan.kim@gmail.com
Subject: Re: 2.6.39-rc4+: oom-killer busy killing tasks
In-Reply-To: <20110429201701.GA13166@x4.trippels.de>
Message-ID: <alpine.DEB.2.01.1104291319270.18728@trent.utfs.org>
References: <alpine.DEB.2.01.1104211841510.18728@trent.utfs.org> <20110424234655.GC12436@dastard> <alpine.DEB.2.01.1104242245090.18728@trent.utfs.org> <alpine.DEB.2.01.1104250015480.18728@trent.utfs.org> <20110427022655.GE12436@dastard>
 <alpine.DEB.2.01.1104270042510.18728@trent.utfs.org> <20110427102824.GI12436@dastard> <alpine.DEB.2.01.1104281008320.18728@trent.utfs.org> <20110428233751.GR12436@dastard> <alpine.DEB.2.01.1104291250480.18728@trent.utfs.org>
 <20110429201701.GA13166@x4.trippels.de>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AV-Checked: ClamAV using ClamSMTP (127.0.0.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Apr 2011 at 22:17, Markus Trippelsdorf wrote:
> I could be the hrtimer bug again. Would you try to reproduce the issue
> with this patch applied?
> http://git.us.kernel.org/?p=linux/kernel/git/tip/linux-2.6-tip.git;a=commit;h=ce31332d3c77532d6ea97ddcb475a2b02dd358b4

will do. Should I enable TREE_RCU again (SMP) or use TINY_RCU for my UP 
system?

Thanks,
C.
-- 
BOFH excuse #221:

The mainframe needs to rest.  It's getting old, you know.
