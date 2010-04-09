Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757462Ab0DIJAT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 05:00:19 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:54943 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1757167Ab0DIJAQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 05:00:16 -0400
Message-ID: <4BBEEC82.6030301@cn.fujitsu.com>
Date: Fri, 09 Apr 2010 16:59:46 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com, mingo@elte.hu
CC: linux-kernel@vger.kernel.org, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com
Subject: Re: [PATCH tip/core/urgent] rcu: updates for RCU lockdep
References: <20100409054701.GA8833@linux.vnet.ibm.com>
In-Reply-To: <20100409054701.GA8833@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For whole patchset:

Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Paul E. McKenney wrote:
> Hello!
> 
> These four patches provides a pair of new APIs and documentation to handle
> a couple of cases that David Howells came across when running an NFS
> workload under CONFIG_PROVE_RCU, along with some comment improvements
> suggested by David and also some by Yong Zhang.
> 
> 							Thanx, Paul
> 
>  b/Documentation/RCU/NMI-RCU.txt   |   39 +++++++++++++++++++++-----------------
>  b/Documentation/RCU/checklist.txt |    7 +++---
>  b/Documentation/RCU/lockdep.txt   |   28 +++++++++++++++++++++++++--
>  b/Documentation/RCU/whatisRCU.txt |    6 +++++
>  b/include/linux/rcupdate.h        |   33 ++++++++++++++++++++++++++++++++
>  include/linux/rcupdate.h          |   30 +++++++++++++++++++++++------
>  6 files changed, 115 insertions(+), 28 deletions(-)
> 
> 

