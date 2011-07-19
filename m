Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab1GSJQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 05:16:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48752 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752460Ab1GSJQv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 05:16:51 -0400
Date: Tue, 19 Jul 2011 10:16:47 +0100
From: Mel Gorman <mgorman@suse.de>
To: Thomas Sattler <tsattler@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Ury Stankevich <urykhy@gmail.com>,
        Andi Kleen <andi@firstfloor.org>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] Fix compaction stalls due to accounting errors in
 isolated page accounting
Message-ID: <20110719091647.GE5349@suse.de>
References: <1307459225-4481-1-git-send-email-mgorman@suse.de>
 <4E22A2BC.2080900@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <4E22A2BC.2080900@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 17, 2011 at 10:52:12AM +0200, Thomas Sattler wrote:
> Hi there ...
> 
> > Re-verification from testers that these patches really do fix their
> > problems would be appreciated. Even if hangs disappear, please confirm
> > that the values for nr_isolated_anon and nr_isolated_file in *both*
> > /proc/zoneinfo and /proc/vmstat are sensible (i.e. usually zero).
> 
> I applied these patches to 2.6.38.8 and it run for nearly a month
> without any problems. Even Though I did not check nr_isolated_*.
> As (at least) patch3 made it into 2.6.39.3 I did not apply the
> others any more. And it occurred again this morning:
> 

I assume you mean it occured again on 2.6.39.3 and so have submitted
them to -stable for 2.6.39.x. You're cc'd so you should hear when or if
they get picked up.

Thanks for testing.

-- 
Mel Gorman
SUSE Labs
