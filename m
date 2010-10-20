Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755744Ab0JTAyE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 20:54:04 -0400
Received: from mga11.intel.com ([192.55.52.93]:13994 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751783Ab0JTAyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 20:54:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,353,1283756400"; 
   d="scan'208";a="848913765"
Date: Wed, 20 Oct 2010 08:54:00 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Tejun Heo <tj@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, lkml <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH wq#for-next] workqueue: Clarify that
 schedule_on_each_cpu is synchronous
Message-ID: <20101020005400.GB5343@localhost>
References: <4CB8725B.9010200@kernel.org>
 <20101018094403.GW30667@csn.ul.ie>
 <20101019133750.A1E6.A69D9226@jp.fujitsu.com>
 <4CBD6276.7070803@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBD6276.7070803@kernel.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 19, 2010 at 05:18:46PM +0800, Tejun Heo wrote:
> The documentation for schedule_on_each_cpu() states that it calls a
> function on each online CPU from keventd.  This can easily be
> interpreted as an asyncronous call because the description does not
> mention that flush_work is called.  Clarify that it is synchronous.
> 
> tj: rephrased a bit
> 
> Signed-off-by: Mel Gorman <mel@csn.ul.ie>
> Reviewed-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>

Nice comment!

Reviewed-by: Wu Fengguang <fengguang.wu@intel.com>
