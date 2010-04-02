Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756286Ab0DBM1G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Apr 2010 08:27:06 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:52925 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751147Ab0DBM05 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Apr 2010 08:26:57 -0400
Message-ID: <4BB5E2A3.3080105@cn.fujitsu.com>
Date: Fri, 02 Apr 2010 20:27:15 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] rcu: don't call rcu_preempt_note_context_switch() in
 rcu_check_callbacks()
References: <4BB014DF.9030905@cn.fujitsu.com> <20100329044236.GB2343@linux.vnet.ibm.com> <4BB1C7C5.5070700@cn.fujitsu.com> <20100330160339.GB2513@linux.vnet.ibm.com> <20100331153656.GA4623@linux.vnet.ibm.com> <4BB3EF25.1040804@cn.fujitsu.com> <20100401011747.GJ2461@linux.vnet.ibm.com> <4BB44A15.60306@cn.fujitsu.com> <20100402005317.GI2472@linux.vnet.ibm.com>
In-Reply-To: <20100402005317.GI2472@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> On Thu, Apr 01, 2010 at 03:24:05PM +0800, Lai Jiangshan wrote:
>> Paul E. McKenney wrote:
>>> Possibly by moving the clearing of RCU_READ_UNLOCK_NEED_QS to
>>> rcu_preempt_check_callbacks() 
>> current rcu_preempt_check_callbacks() already has code to
>> clear RCU_READ_UNLOCK_NEED_QS.
> 
> English is failing me. 
> How about the following patch instead?  Untested,
> probably does not even compile.
> 
> 							Thanx, Paul
> 

Very nice, thank you.

Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>

