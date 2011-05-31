Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756911Ab1EaEyh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 00:54:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:51297 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750978Ab1EaEyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 00:54:35 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DE4747D.7040902@jp.fujitsu.com>
Date: Tue, 31 May 2011 13:54:21 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: rientjes@google.com
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, caiqian@redhat.com, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, minchan.kim@gmail.com, oleg@redhat.com
Subject: Re: [PATCH 4/5] oom: don't kill random process
References: <4DD61F80.1020505@jp.fujitsu.com> <4DD6207E.1070300@jp.fujitsu.com> <alpine.DEB.2.00.1105231529340.17840@chino.kir.corp.google.com> <4DDB0B45.2080507@jp.fujitsu.com> <alpine.DEB.2.00.1105231838420.17729@chino.kir.corp.google.com> <4DDB1028.7000600@jp.fujitsu.com> <alpine.DEB.2.00.1105231856210.18353@chino.kir.corp.google.com> <4DDB11F4.2070903@jp.fujitsu.com> <alpine.DEB.2.00.1105251645270.29729@chino.kir.corp.google.com> <4DE2F028.6020608@jp.fujitsu.com> <alpine.DEB.2.00.1105302147250.18793@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1105302147250.18793@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/31 13:48), David Rientjes wrote:
> On Mon, 30 May 2011, KOSAKI Motohiro wrote:
> 
>> Never mind.
>>
>> You never see to increase tasklist_lock. You never seen all processes
>> have root privilege case.
> 
> I don't really understand what you're trying to say, sorry.

It's no for job server workload. I mean.


