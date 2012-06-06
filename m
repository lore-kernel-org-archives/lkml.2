Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755510Ab2FFJmO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 05:42:14 -0400
Received: from relay1.sgi.com ([192.48.179.29]:57232 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab2FFJmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 05:42:12 -0400
Date: Wed, 6 Jun 2012 04:42:11 -0500
From: Robin Holt <holt@sgi.com>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Robin Holt <holt@sgi.com>, WANG Cong <xiyou.wangcong@gmail.com>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Commit 722bc6b167 breaks booting on an 8TB system.
Message-ID: <20120606094211.GL4948@sgi.com>
References: <20120601155447.GG3671@sgi.com>
 <CAE9FiQWJR6x4_Xhc2k5TFkCj2u5cpbcWf-jFWOB5pEuBQcoJrQ@mail.gmail.com>
 <20120604100700.GA4948@sgi.com>
 <CAE9FiQW_yBZZKsVt5Fy7QEqa7hBXhfbka4Ubh=oz4hDOzLQ0mg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAE9FiQW_yBZZKsVt5Fy7QEqa7hBXhfbka4Ubh=oz4hDOzLQ0mg@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 04:51:19PM -0700, Yinghai Lu wrote:
> On Mon, Jun 4, 2012 at 3:07 AM, Robin Holt <holt@sgi.com> wrote:
> > On Sun, Jun 03, 2012 at 12:00:29AM -0700, Yinghai Lu wrote:
> >> On Fri, Jun 1, 2012 at 8:54 AM, Robin Holt <holt@sgi.com> wrote:
> >> > I just tried to boot an 8TB system.  It fails very early in boot with:
> >> >
> >> > Kernel panic - not syncing: Cannot find space for the kernel page tables
> >> >
> >> >
> >> > A git bisect lead me to commit 722bc6b16771ed80871e1fd81c86d3627dda2ac8.
> >> >
> >> > A git revert of that commit based on Linus' current as of a few hours ago
> >> > (commit fb21aff) does boot past that point on the 8TB configuration.
> >>
> >> have some local patches. please check if they are helping...
> >
> > I will not have access to the machine until late tonight/early tomorrow
> > (approximately 24 hours from now).  I will try to give the patches a
> > run then.  Would you like them tested individually or as a set?
> 
> only_need_recalculate_for_low.patch
> 
> should be enough.

With just that patch, no improvement.

Sorry about the delay.  I got bumped from the machine yesterday.
The next reservable time is tomorrow night, otherwise, the machine is
booked solid for the next 36 hours.

Robin
