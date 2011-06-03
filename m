Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751567Ab1FCFDl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 01:03:41 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34153 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751343Ab1FCFDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 01:03:39 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE86B37.4070704@jp.fujitsu.com>
Date: Fri, 03 Jun 2011 14:03:51 +0900
From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Thunderbird/3.1.10
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: rostedt@goodmis.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        nhorman@tuxdriver.com, mingo@elte.hu, fweisbec@gmail.com,
        mathieu.desnoyers@efficios.com, tglx@linutronix.de,
        kosaki.motohiro@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        kaneshige.kenji@jp.fujitsu.com
Subject: Re: [PATCH] ftrace: tracepoint of net_dev_xmit sees freed skb and
 causes panic
References: <1306854867.11899.31.camel@gandalf.stny.rr.com>	<20110602.135913.2065173997860104604.davem@davemloft.net>	<1307048512.3667.28.camel@gandalf.stny.rr.com> <20110602.140426.765650914977149734.davem@davemloft.net>
In-Reply-To: <20110602.140426.765650914977149734.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/03 6:04), David Miller wrote:
> From: Steven Rostedt <rostedt@goodmis.org>
> Date: Thu, 02 Jun 2011 17:01:52 -0400
> 
>> On Thu, 2011-06-02 at 13:59 -0700, David Miller wrote:
>>> From: Steven Rostedt <rostedt@goodmis.org>
>>> Date: Tue, 31 May 2011 11:14:27 -0400
>>>
>>>> Note, the subject should not be "ftrace:", but "net:" or maybe even
>>>> "net/tracing", as this really has nothing to do with ftrace code. The
>>>> tracepoints are more generic than ftrace.
>>>
>>> Do you guys mind if I take this in via the net-2.6 tree?
>>
>> I have no issue with that. Heck, I prefer it.
> 
> Great, thanks!

O.K.
I will resubmit this patch with appropriate subject "net/tracing:"

Thanks,
Koki Sanagi

