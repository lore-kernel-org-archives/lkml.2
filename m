Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757882Ab0DIVZ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 17:25:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757766Ab0DIVZ4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 17:25:56 -0400
Message-ID: <4BBF9B34.5040909@redhat.com>
Date: Fri, 09 Apr 2010 17:25:08 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Lightning/1.0b2pre Thunderbird/3.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Shaohua Li <shaohua.li@intel.com>,
       "Wu, Fengguang" <fengguang.wu@intel.com>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]vmscan: handle underflow for get_scan_ratio
References: <20100331045348.GA3396@sli10-desk.sh.intel.com>	<20100331142708.039E.A69D9226@jp.fujitsu.com>	<20100331145030.03A1.A69D9226@jp.fujitsu.com>	<20100402065052.GA28027@sli10-desk.sh.intel.com>	<20100406050325.GA17797@localhost>	<20100409065104.GA21480@sli10-desk.sh.intel.com> <20100409142057.be0ce5af.akpm@linux-foundation.org>
In-Reply-To: <20100409142057.be0ce5af.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2010 05:20 PM, Andrew Morton wrote:

> Come to that, it's not obvious that we need this in 2.6.34 either.  What
> is the user-visible impact here?

I suspect very little impact, especially during workloads
where we can just reclaim clean page cache at DEF_PRIORITY.
FWIW, the patch looks good to me, so:

Acked-by: Rik van Riel <riel@redhat.com>

