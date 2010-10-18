Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243Ab0JRAGv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 20:06:51 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:34903 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751830Ab0JRAGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 20:06:50 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 18 Oct 2010 09:01:23 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH v2.6.36-rc7] memory_hotplug: drop spurious calls to
 flush_scheduled_work()
Message-Id: <20101018090123.5afe4abf.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4CB8725B.9010200@kernel.org>
References: <4CB8725B.9010200@kernel.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010 17:25:15 +0200
Tejun Heo <tj@kernel.org> wrote:

> lru_add_drain_all() uses schedule_on_each_cpu() which is synchronous.
> There is no reason to call flush_scheduled_work() after
> lru_add_drain_all().  Drop the spurious calls.
> 
> This is to prepare for the deprecation and removal of
> flush_scheduled_work().
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

