Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab2ERHcP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 03:32:15 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:61086 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1759333Ab2ERHcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 03:32:13 -0400
X-IronPort-AV: E=Sophos;i="4.75,615,1330876800"; 
   d="scan'208";a="4986507"
Message-ID: <4FB5FC6D.4020709@cn.fujitsu.com>
Date: Fri, 18 May 2012 15:38:21 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org,
        "Paul E. McKenney" <paul.mckenney@linaro.org>
Subject: Re: [PATCH RFC tip/core/rcu 1/2] rcu: Fix code-style issues involving
 "else"
References: <20120517221217.GA12196@linux.vnet.ibm.com> <1337292765-12221-1-git-send-email-paulmck@linux.vnet.ibm.com>
In-Reply-To: <1337292765-12221-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/18 15:30:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/05/18 15:30:55,
	Serialize complete at 2012/05/18 15:30:55
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/18/2012 06:12 AM, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paul.mckenney@linaro.org>
> 
> The Linux kernel coding style says that single-statement blocks should
> omit curly braces unless the other leg of the "if" statement has
> multiple statements, in which case the curly braces should be included.
> This commit fixes RCU's violations of this rule.
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> ---
>  kernel/rcutiny_plugin.h |    3 ++-
>  kernel/rcutorture.c     |    3 ++-
>  kernel/rcutree.c        |    7 ++++---
>  kernel/rcutree_plugin.h |   18 ++++++++++--------
>  4 files changed, 18 insertions(+), 13 deletions(-)
> 

Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
