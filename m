Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932509Ab1ERAPF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 20:15:05 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:50278 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756443Ab1ERAPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 20:15:03 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DD30F7B.3000206@jp.fujitsu.com>
Date: Wed, 18 May 2011 09:14:51 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: davem@davemloft.net
CC: linux-kernel@vger.kernel.org, therbert@google.com, eric.dumazet@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: cpuvert to new cpumask API
References: <20110428235813.3D5A.A69D9226@jp.fujitsu.com> <20110516.115357.193701317.davem@davemloft.net>
In-Reply-To: <20110516.115357.193701317.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/05/17 3:53), David Miller wrote:
> From: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
> Date: Thu, 28 Apr 2011 23:56:35 +0900 (JST)
>
>> We plan to remove cpu_xx() old api later. Thus this patch
>> convert it.
>>
>> This patch has no functional change.
>>
>> Signed-off-by: KOSAKI Motohiro<kosaki.motohiro@jp.fujitsu.com>
>
> Applied, thanks.

Great! :)



