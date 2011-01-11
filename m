Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755577Ab1AKKN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 05:13:58 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:43186 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab1AKKNw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 05:13:52 -0500
Date: Tue, 11 Jan 2011 15:43:46 +0530
From: Bharata B Rao <bharata@linux.vnet.ibm.com>
To: Yong Zhang <yong.zhang0@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH -tip 1/2] sched: Reinstate group names in
 /proc/sched_debug.
Message-ID: <20110111101346.GG4772@in.ibm.com>
Reply-To: bharata@linux.vnet.ibm.com
References: <20110110051445.GB2772@in.ibm.com>
 <20110110051551.GC2772@in.ibm.com>
 <AANLkTi=kEFcJ183xUCXGL=QqPLnOYBNtpQ=i5F9kTwK4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=kEFcJ183xUCXGL=QqPLnOYBNtpQ=i5F9kTwK4@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 11, 2011 at 09:53:05AM +0800, Yong Zhang wrote:
> On Mon, Jan 10, 2011 at 1:15 PM, Bharata B Rao
> <bharata@linux.vnet.ibm.com> wrote:
> > sched: Reinstate group names in /proc/sched_debug.
> >
> > Displaying of group names in /proc/sched_debug was dropped in autogroup
> > patches. Add group names while displaying cfs_rq and tasks information.
> >
> > Signed-off-by: Bharata B Rao <bharata@linux.vnet.ibm.com>
> > ---
> > @@ -144,7 +167,11 @@ void print_cfs_rq(struct seq_file *m, in
> >        struct sched_entity *last;
> >        unsigned long flags;
> >
> > +#if defined(CONFIG_CGROUP_SCHED) && defined(CONFIG_FAIR_GROUP_SCHED)
> 
> defined(CONFIG_CGROUP_SCHED) is not necessary here,
> CONFIG_[FAIR|RT]_GROUP_SCHED always imply CONFIG_CGROUP_SCHED

Took care of this in my latest post.

Thanks,
Bharata.
