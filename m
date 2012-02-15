Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756405Ab2BOXuT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 18:50:19 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57234 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2BOXuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 18:50:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Feb 2012 08:48:31 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Righi <andrea@betterlinux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shaohua Li <shaohua.li@intel.com>,
        =?UTF-8?B?UMOhZHJhaWc=?= Brady <P@draigBrady.com>,
        John Stultz <john.stultz@linaro.org>,
        Jerry James <jamesjer@betterlinux.com>,
        Julius Plenz <julius@plenz.com>, Greg Thelen <gthelen@google.com>,
        linux-mm <linux-mm@kvack.org>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] [PATCH v5 0/3] fadvise: support POSIX_FADV_NOREUSE
Message-Id: <20120216084831.0a6ef4f2.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120215012957.GA1728@thinkpad>
References: <1329006098-5454-1-git-send-email-andrea@betterlinux.com>
	<20120214133337.9de7835b.akpm@linux-foundation.org>
	<20120214225922.GA12394@thinkpad>
	<20120214152220.4f621975.akpm@linux-foundation.org>
	<20120215012957.GA1728@thinkpad>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Feb 2012 02:35:24 +0100
Andrea Righi <andrea@betterlinux.com> wrote:

> On Tue, Feb 14, 2012 at 03:22:20PM -0800, Andrew Morton wrote:
> > On Tue, 14 Feb 2012 23:59:22 +0100
> > Andrea Righi <andrea@betterlinux.com> wrote:
> > 
> > > On Tue, Feb 14, 2012 at 01:33:37PM -0800, Andrew Morton wrote:
> > > > On Sun, 12 Feb 2012 01:21:35 +0100
> > > > Andrea Righi <andrea@betterlinux.com> wrote: 
> > > > And yes, a container-based approach is pretty crude, and one can
> > > > envision applications which only want modified reclaim policy for one
> > > > particualr file.  But I suspect an application-wide reclaim policy
> > > > solves 90% of the problems.
> > > 
> > > I really like the container-based approach. But for this we need a
> > > better file cache control in the memory cgroup; now we have the
> > > accounting of file pages, but there's no way to limit them.
> > 
> > Again, if/whem memcg becomes sufficiently useful for this application
> > we're left maintaining the obsolete POSIX_FADVISE_NOREUSE for ever.
> 
> Yes, totally agree. For the future a memcg-based solution is probably
> the best way to go.
> 
> This reminds me to the old per-memcg dirty memory discussion
> (http://thread.gmane.org/gmane.linux.kernel.mm/67114), cc'ing Greg.
> 
> Maybe the generic feature to provide that could solve both problems is
> a better file cache isolation in memcg.
> 

Can you think of example interface for us ?
I'd like to discuss this in mm-summit if we have a chance.

Thanks,
-Kame

