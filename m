Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752136Ab0ICFNI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 01:13:08 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36804 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab0ICFNG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 01:13:06 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C8083D5.200@jp.fujitsu.com>
Date: Fri, 03 Sep 2010 14:12:53 +0900
From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: David Miller <davem@davemloft.net>, rostedt@goodmis.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kaneshige.kenji@jp.fujitsu.com, izumi.taku@jp.fujitsu.com,
        kosaki.motohiro@jp.fujitsu.com, nhorman@tuxdriver.com,
        laijs@cn.fujitsu.com, scott.a.mcmillan@intel.com,
        eric.dumazet@gmail.com, mathieu.desnoyers@polymtl.ca
Subject: Re: [PATCH v4 0/5] netdev: show a process of packets
References: <4C72422C.5070102@jp.fujitsu.com> <1283212210.3656.84.camel@gandalf.stny.rr.com> <4C80592B.2060406@jp.fujitsu.com> <20100902.191741.233696520.davem@davemloft.net> <4C806388.9020509@jp.fujitsu.com> <20100903044656.GA6589@nowhere>
In-Reply-To: <20100903044656.GA6589@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/09/03 13:46), Frederic Weisbecker wrote:
> On Fri, Sep 03, 2010 at 11:55:04AM +0900, Koki Sanagi wrote:
>> (2010/09/03 11:17), David Miller wrote:
>>> From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
>>> Date: Fri, 03 Sep 2010 11:10:51 +0900
>>>
>>>> Thanks many acks. and I have one question.
>>>>
>>>> These patches have several component.
>>>>
>>>> Patch1 is kernel component, but patch2-5 are netdev component.
>>>> What tree is good to be included ?
>>>> If it is not net-next, I must rebase to another tree.
>>>
>>> I would prefer it goes into the tracing tree or whatever is the most appropriate
>>> for patch #1.
>>>
>>
>> O.K. I'll rebase to linux-2.6-tip.
> 
> 
> No need, they apply very well :)
> 
> I'll push that to -tip soon.
> 
> Thanks.
> 

O.K. Thanks!

Koki Sanagi.


