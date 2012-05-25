Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932932Ab2EYVEd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 17:04:33 -0400
Received: from www.linutronix.de ([62.245.132.108]:39983 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab2EYVEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 17:04:31 -0400
Date: Fri, 25 May 2012 23:04:25 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Chris Metcalf <cmetcalf@tilera.com>
cc: Gilad Ben-Yossef <gilad@benyossef.com>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Mike Frysinger <vapier@gentoo.org>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Christoph Lameter <cl@linux.com>, Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org
Subject: Re: [PATCH v1 1/6] timer: make __next_timer_interrupt explicit about
 no future event
In-Reply-To: <4FBFF1F0.6050802@tilera.com>
Message-ID: <alpine.LFD.2.02.1205252301160.3231@ionos>
References: <1336056962-10465-1-git-send-email-gilad@benyossef.com> <1336056962-10465-2-git-send-email-gilad@benyossef.com> <alpine.LFD.2.02.1205251846520.3231@ionos> <4FBFF1F0.6050802@tilera.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 25 May 2012, Chris Metcalf wrote:

> On 5/25/2012 4:48 PM, Thomas Gleixner wrote:
> >> I've noticed a similar but slightly different fix to the
> >> > same problem in the Tilera kernel tree from Chris M. (I've
> >> > wrote this before seeing that one), so some variation of this
> >> > fix is in use on real hardware for some time now.
> > Sigh, why can't people post their fixes instead of burying them in
> > their private trees?
> 
> The tree was never really ready for review.  I pushed the tree just for
> reference to the nohz cpusets work, and so that I have something I can
> refer people to when I start participating more actively in that discussion.
> 
> It didn't seem useful to post a single patch by itself without more
> motivating examples behind it (i.e. without the entirety of the tree).

The code does the Wrong Thing. Independent of nohz cpusets or
whatever.

Aside of that this is also relevant for power saving stuff.

Thanks,

	tglx
