Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754979Ab0JTAZo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 20:25:44 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:33923 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751391Ab0JTAZm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 20:25:42 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 20 Oct 2010 09:20:11 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Tejun Heo <tj@kernel.org>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Mel Gorman <mel@csn.ul.ie>, lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH wq#for-next] workqueue: Clarify that
 schedule_on_each_cpu is synchronous
Message-Id: <20101020092011.62bff582.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4CBD6276.7070803@kernel.org>
References: <4CB8725B.9010200@kernel.org>
	<20101018094403.GW30667@csn.ul.ie>
	<20101019133750.A1E6.A69D9226@jp.fujitsu.com>
	<4CBD6276.7070803@kernel.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 11:18:46 +0200
Tejun Heo <tj@kernel.org> wrote:

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

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

