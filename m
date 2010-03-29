Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab0C2Nwv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:52:51 -0400
Received: from hera.kernel.org ([140.211.167.34]:39543 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750925Ab0C2Nwt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:52:49 -0400
Message-ID: <4BB0B13F.9080800@kernel.org>
Date: Mon, 29 Mar 2010 22:55:11 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.8) Gecko/20100227 Thunderbird/3.0.3
MIME-Version: 1.0
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
CC: Peter Zijlstra <peterz@infradead.org>,
       Lai Jiangshan <laijs@cn.fujitsu.com>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, dipankar@in.ibm.com,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com
Subject: Re: [RFC patch] extable and module add object is static
References: <20100327153233.993367557@efficios.com> <20100327224606.GK2343@linux.vnet.ibm.com> <20100327231421.GA4685@Krystal> <20100327232024.GB4685@Krystal> <20100327234314.GL2343@linux.vnet.ibm.com> <20100328000234.GA4924@Krystal> <4BB004ED.5060106@cn.fujitsu.com> <1269852814.12097.167.camel@laptop> <20100329131633.GA22730@Krystal>
In-Reply-To: <20100329131633.GA22730@Krystal>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 29 Mar 2010 13:52:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 03/29/2010 10:16 PM, Mathieu Desnoyers wrote:
> That's great! Tejun, can you point me out to an update version of these
> patches ? I am particularly interested in being able to know the range of
> statically defined per-cpu data.

  http://thread.gmane.org/gmane.linux.kernel/958794/focus=959493

These were waiting for Rusty's ACK.  They got ACKed today and will be
pushed to mainline through percpu tree soonish.

Thanks.

-- 
tejun
