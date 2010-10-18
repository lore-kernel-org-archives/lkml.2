Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612Ab0JSAEX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:04:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:57296 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932205Ab0JSAEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:04:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 19 Oct 2010 08:58:56 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH v2.6.36-rc7] memory_hotplug: drop spurious calls to
 flush_scheduled_work()
Message-Id: <20101019085856.af21cfa7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4CBBD529.8060600@kernel.org>
References: <4CB8725B.9010200@kernel.org>
	<20101018090123.5afe4abf.kamezawa.hiroyu@jp.fujitsu.com>
	<4CBBD529.8060600@kernel.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Oct 2010 07:03:37 +0200
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On 10/18/2010 02:01 AM, KAMEZAWA Hiroyuki wrote:
> > On Fri, 15 Oct 2010 17:25:15 +0200
> > Tejun Heo <tj@kernel.org> wrote:
> > 
> >> lru_add_drain_all() uses schedule_on_each_cpu() which is synchronous.
> >> There is no reason to call flush_scheduled_work() after
> >> lru_add_drain_all().  Drop the spurious calls.
> >>
> >> This is to prepare for the deprecation and removal of
> >> flush_scheduled_work().
> >>
> >> Signed-off-by: Tejun Heo <tj@kernel.org>
> > Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Through which tree should this be routed?  Shall I route this via the
> wq tree?
> 
please.

Thank,
-Kame

