Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab1ESKMX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 06:12:23 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:35637 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab1ESKMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 06:12:22 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD4ECF4.9050105@jp.fujitsu.com>
Date: Thu, 19 May 2011 19:12:04 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: a.p.zijlstra@chello.nl
CC: yong.zhang0@gmail.com, paulmck@linux.vnet.ibm.com, oleg@redhat.com,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org, mingo@elte.hu,
        lizf@cn.fujitsu.com, miaox@cn.fujitsu.com
Subject: Re: [PATCH v2 1/2] rcu: don't bind offline cpu
References: <20110428161149.GA15658@redhat.com>	 <20110502194416.2D61.A69D9226@jp.fujitsu.com>	 <20110502195657.2D68.A69D9226@jp.fujitsu.com>	 <1305129929.2914.247.camel@laptop> <4DCCC61F.80408@jp.fujitsu.com>	 <BANLkTik_weiOC82uRKRamFan4QMi1u3s7g@mail.gmail.com>	 <20110515185547.GL2258@linux.vnet.ibm.com> <20110516132623.GA2058@zhy>	 <4DD4B358.3080705@jp.fujitsu.com> <1305794078.2466.7193.camel@twins>	 <4DD4D9EB.2040603@jp.fujitsu.com> <1305798113.2466.7216.camel@twins>
In-Reply-To: <1305798113.2466.7216.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/19 18:41), Peter Zijlstra wrote:
> On Thu, 2011-05-19 at 17:50 +0900, KOSAKI Motohiro wrote:
>> I'm sorry. Please give me a bit time.
>
> N/P, as I've already found out CPU_STARTING isn't a suitable location
> either.
>
> How about something like the below...

latest -tip + my cpuset_cpus_allowed_fallback() fix + this patch works completely!

Thanks.


