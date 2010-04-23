Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756750Ab0DWJBG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 05:01:06 -0400
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.15]:48965
	"EHLO VA3EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756467Ab0DWJBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 05:01:03 -0400
X-SpamScore: -22
X-BigFish: VPS-22(zz1432P98dN936eM62a3Lzz1202hzz6ff19hz32i2a8h43h61h)
X-Spam-TCS-SCL: 0:0
X-WSS-ID: 0L1BNPB-02-8Z1-02
X-M-MSG: 
Date: Fri, 23 Apr 2010 11:00:45 +0200
From: Robert Richter <robert.richter@amd.com>
To: Andrew Morton <akpm@linux-foundation.org>
CC: John Villalovos <sodarock@gmail.com>, Andi Kleen <andi@firstfloor.org>,
       oprofile-list@lists.sf.net, linux-kernel@vger.kernel.org,
       rostedt@goodmis.org, stable@kernel.org
Subject: Re: [PATCH] oprofile: remove double ring buffering
Message-ID: <20100423090045.GI6450@erda.amd.com>
References: <20100401011725.GA27567@basil.fritz.box>
 <20100401190205.GD6027@erda.amd.com>
 <m2h5e61b72f1004220733n65451418p7c321f07eb5d6b58@mail.gmail.com>
 <20100422160411.cfcae4e1.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20100422160411.cfcae4e1.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 23 Apr 2010 09:00:46.0271 (UTC) FILETIME=[762E0CF0:01CAE2C3]
X-Reverse-DNS: unknown
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.04.10 16:04:11, Andrew Morton wrote:
> > I was wondering what the state of this patch is.  I don't see it in
> > linux-2.6 or linux-next. or in
> > git://git.kernel.org/pub/scm/linux/kernel/git/rric/oprofile.git
> > 
> 
> I queued it in my for-2.6.34-via-subsystem-maintainer pile.  I'll start
> sending those things out for everyone to ignore early next week I guess.

I just make my tree ready for v2.6.35 and will put it in there.

The patch looks good, will run some tests.

-Robert

-- 
Advanced Micro Devices, Inc.
Operating System Research Center
email: robert.richter@amd.com

