Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755006Ab2BUBHc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 20:07:32 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:52112 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab2BUBHb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 20:07:31 -0500
Message-ID: <4F42EF53.6060400@cn.fujitsu.com>
Date: Tue, 21 Feb 2012 09:11:47 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        fweisbec@gmail.com, patches@linaro.org
Subject: Re: [PATCH RFC tip/core/rcu] rcu: direct algorithmic SRCU implementation
References: <20120213020951.GA12138@linux.vnet.ibm.com> <4F41F315.1040900@cn.fujitsu.com> <20120220174418.GI2470@linux.vnet.ibm.com>
In-Reply-To: <20120220174418.GI2470@linux.vnet.ibm.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-21 09:05:41,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-02-21 09:05:48,
	Serialize complete at 2012-02-21 09:05:48
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2012 01:44 AM, Paul E. McKenney wrote:

> 
>> My conclusion, we can just remove the check-and-return path to reduce
>> the complexity since we will introduce call_srcu().
> 
> If I actually submit the above upstream, that would be quite reasonable.
> My thought is that patch remains RFC and the upstream version has
> call_srcu().

Does the work of call_srcu() is started or drafted?

> 
>> This new srcu is very great, especially the SRCU_USAGE_COUNT for every
>> lock/unlock witch forces any increment/decrement pair changes the counter
>> for me.
> 
> Glad you like it!  ;-)
> 
> And thank you for your review and feedback!

Could you add my Reviewed-by when this patch is last submitted?


Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thanks
Lai
