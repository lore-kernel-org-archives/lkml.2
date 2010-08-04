Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932686Ab0HDNyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 09:54:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932576Ab0HDNyg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 09:54:36 -0400
Date: Wed, 4 Aug 2010 09:54:17 -0400
From: Don Zickus <dzickus@redhat.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Cyrill Gorcunov <gorcunov@gmail.com>, robert.richter@amd.com,
        fweisbec@gmail.com, linux-kernel@vger.kernel.org,
        "Huang, Ying" <ying.huang@intel.com>
Subject: Re: A question of perf NMI handler
Message-ID: <20100804135417.GM3353@redhat.com>
References: <1280913670.20797.179.camel@minggr.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1280913670.20797.179.camel@minggr.sh.intel.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 04, 2010 at 05:21:10PM +0800, Lin Ming wrote:
> With nmi_watchdog enabled, perf_event_nmi_handler always return
> NOTIFY_STOP(active_events > 0), and the notifier call chain will not
> call further.
> 
> If it was not perf NMI, does the perf nmi handler may stop the real NMI
> handler get called because NOTIFY_STOP is returned??

Yes I sent a cheap and dirty patch to address this a couple of weeks ago

http://lkml.indiana.edu/hypermail//linux/kernel/1007.2/02590.html

Unfortunately, no responded. :-(  Of course, it could have been so gross
no one wanted to comment on it. :-)

Cheers,
Don
