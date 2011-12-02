Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753592Ab1LBJ6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 04:58:11 -0500
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:37063 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753210Ab1LBJ6J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 04:58:09 -0500
Date: Fri, 2 Dec 2011 15:27:56 +0530
From: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] nohz: Remove update_ts_time_stat from
 tick_nohz_start_idle
Message-ID: <20111202095756.GB15975@linux.vnet.ibm.com>
Reply-To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
References: <1322755222-6951-1-git-send-email-mhocko@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <1322755222-6951-1-git-send-email-mhocko@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 11120123-7014-0000-0000-00000031DB25
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Michal Hocko <mhocko@suse.cz> [2011-12-01 17:00:22]:

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

Reviewed-by: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>

