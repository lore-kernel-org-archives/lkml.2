Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758619Ab2EYU4T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:56:19 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:52207 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753461Ab2EYU4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:56:18 -0400
Message-ID: <4FBFF1F0.6050802@tilera.com>
Date: Fri, 25 May 2012 16:56:16 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Gilad Ben-Yossef <gilad@benyossef.com>, <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, Mike Frysinger <vapier@gentoo.org>,
        David Rientjes <rientjes@google.com>, Hugh Dickins <hughd@google.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Christoph Lameter <cl@linux.com>, Hakan Akkan <hakanakkan@gmail.com>,
        Max Krasnyansky <maxk@qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, <linux-mm@kvack.org>
Subject: Re: [PATCH v1 1/6] timer: make __next_timer_interrupt explicit about
 no future event
References: <1336056962-10465-1-git-send-email-gilad@benyossef.com> <1336056962-10465-2-git-send-email-gilad@benyossef.com> <alpine.LFD.2.02.1205251846520.3231@ionos>
In-Reply-To: <alpine.LFD.2.02.1205251846520.3231@ionos>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/2012 4:48 PM, Thomas Gleixner wrote:
>> I've noticed a similar but slightly different fix to the
>> > same problem in the Tilera kernel tree from Chris M. (I've
>> > wrote this before seeing that one), so some variation of this
>> > fix is in use on real hardware for some time now.
> Sigh, why can't people post their fixes instead of burying them in
> their private trees?

The tree was never really ready for review.  I pushed the tree just for
reference to the nohz cpusets work, and so that I have something I can
refer people to when I start participating more actively in that discussion.

It didn't seem useful to post a single patch by itself without more
motivating examples behind it (i.e. without the entirety of the tree).

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

