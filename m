Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab1LBApX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 19:45:23 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:33341 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab1LBApW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 19:45:22 -0500
Date: Fri, 2 Dec 2011 01:45:17 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] nohz: Remove update_ts_time_stat from
 tick_nohz_start_idle
Message-ID: <20111202004513.GA15880@somewhere.redhat.com>
References: <1322755222-6951-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322755222-6951-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 05:00:22PM +0100, Michal Hocko wrote:
> There is no reason to call update_ts_time_stat from tick_nohz_start_idle
> anymore (after e0e37c20 sched: Eliminate the ts->idle_lastupdate field)
> when we updated idle_lastupdate unconditionally.
> 
> We haven't set idle_active yet and do not provide last_update_time so
> the whole call end up being just 2 wasted branches.
> 
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> CC: Arjan van de Ven <arjan@linux.intel.com>
> CC: Thomas Gleixner <tglx@linutronix.de>

Reviewed-by Frederic Weisbecker <fweisbec@gmail.com>
