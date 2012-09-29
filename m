Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030686Ab2I2CdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 22:33:09 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:40756 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759437Ab2I2Cci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 22:32:38 -0400
Message-ID: <50665DBF.6090106@linux.vnet.ibm.com>
Date: Sat, 29 Sep 2012 10:32:31 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, dipankar@in.ibm.com
Subject: Re: [PATCH 0/7] rcu: optimize RCU trace on the huge platform
References: <1348102268-3544-1-git-send-email-wangyun@linux.vnet.ibm.com> <20120928175301.GC2498@linux.vnet.ibm.com>
In-Reply-To: <20120928175301.GC2498@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12092902-0260-0000-0000-000001EA1512
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2012 01:53 AM, Paul E. McKenney wrote:
> On Thu, Sep 20, 2012 at 08:51:01AM +0800, Michael Wang wrote:
>> This patch set optimize the RCU trace to make it perform better on the
>> platform with thousands of cpus.
>>
>> The optimization including:
>> 	-- the cpu info will be separated by each flavor of rcu.
>> 	-- implement the 'cpu units sequence reading' to avoid losing data.
>>
>> Michael Wang (7):
>> 	[PATCH 1/7] rcu: create directory for each flavor of rcu
>> 	[PATCH 2/7] rcu: fundamental facility for 'cpu units sequence reading'
>> 	[PATCH 3/7] rcu: optimize the 'rcudata' for RCU trace
>> 	[PATCH 4/7] rcu: optimize the 'rcudata.csv' for RCU trace
>> 	[PATCH 5/7] rcu: optimize the 'rcu_pending' for RCU trace
>> 	[PATCH 6/7] rcu: replace the old interface with the new one
>> 	[PATCH 7/7] rcu: remove the interface "rcudata.csv"
>>
>> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
>> ---
>>  b/kernel/rcutree_trace.c |    8 +
>>  kernel/rcutree_trace.c   |  368 ++++++++++++++++++++---------------------------
>>  2 files changed, 170 insertions(+), 206 deletions(-)
> 
> Queued for 3.8, thank you Michael!

Thanks for your review.

Regards,
Michael Wang

> 
> 							Thanx, Paul
> 

