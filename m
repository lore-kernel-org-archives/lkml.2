Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758144Ab0JSJTh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 05:19:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:45496 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab0JSJTf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 05:19:35 -0400
Message-ID: <4CBD6289.8050603@kernel.org>
Date: Tue, 19 Oct 2010 11:19:05 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: lkml <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Wu Fengguang <fengguang.wu@intel.com>, Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH v2.6.36-rc7] memory_hotplug: drop spurious calls to flush_scheduled_work()
References: <4CB8725B.9010200@kernel.org>	<20101018090123.5afe4abf.kamezawa.hiroyu@jp.fujitsu.com>	<4CBBD529.8060600@kernel.org> <20101019085856.af21cfa7.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101019085856.af21cfa7.kamezawa.hiroyu@jp.fujitsu.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 19 Oct 2010 09:19:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 01:58 AM, KAMEZAWA Hiroyuki wrote:
>> Through which tree should this be routed?  Shall I route this via the
>> wq tree?
>>
> please.

Applied to wq#for-next.  Thank you.

-- 
tejun
