Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab0FYHvK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 03:51:10 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:38644 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab0FYHvI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 03:51:08 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4C245FE9.2050606@jp.fujitsu.com>
Date: Fri, 25 Jun 2010 16:51:05 +0900
From: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, kaneshige.kenji@jp.fujitsu.com,
       izumi.taku@jp.fujitsu.com, Lai Jiangshan <laijs@cn.fujitsu.com>
Subject: Re: [RFC PATCH v2 1/5] irq: add tracepoint to softirq_raise
References: <4C2312A8.9060903@jp.fujitsu.com> <4C23FF0E.4020908@jp.fujitsu.com> <20100625100718.8034.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100625100718.8034.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Kosaki,

I'll fix a description.

(2010/06/25 10:10), KOSAKI Motohiro wrote:
> (cc to Lai)
> 
>> This patch adds a tracepoint to raising of softirq.
>> This is useful if you want to detect which hard interrupt raise softirq
>> and lets you know a time between raising softirq and performing softirq.
>> Combinating with other tracepoint, it lets us know a process of packets
>> (See patch 0/5).
>>
>>           <idle>-0     [001] 241229.957184: softirq_raise: vec=3 [action=NET_RX]
>>           <idle>-0     [000] 241229.993399: softirq_raise: vec=1 [action=TIMER]
>>           <idle>-0     [000] 241229.993400: softirq_raise: vec=9 [action=RCU]
>>
>> This is a same patch Lai Jiangshan submitted.
>> http://marc.info/?l=linux-kernel&m=126026122728732&w=2
> 
> If so, you shouldn't remove author's info. please fix the description
> as following.
> 
> -------------------------------------------------------------------------
> From: Lai Jiangshan <laijs@cn.fujitsu.com>
> 
> This patch adds a tracepoint to raising of softirq.
> This is useful if you want to detect which hard interrupt raise softirq
> and lets you know a time between raising softirq and performing softirq.
> Combinating with other tracepoint, it lets us know a process of packets
> (See patch 0/5).
> 
>           <idle>-0     [001] 241229.957184: softirq_raise: vec=3 [action=NET_RX]
>           <idle>-0     [000] 241229.993399: softirq_raise: vec=1 [action=TIMER]
>           <idle>-0     [000] 241229.993400: softirq_raise: vec=9 [action=RCU]
> 
> This is a same below.
> http://marc.info/?l=linux-kernel&m=126026122728732&w=2
> 
> Signed-off-by: Lai Jiangshan <laijs@cn.fujitsu.com>
> Acked-by: Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>
> Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Koki Sanagi <sanagi.koki@jp.fujitsu.com>
> --------------------------------------------------------------------------------
> 
> 
> 
> 


