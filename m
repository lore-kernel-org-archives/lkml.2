Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab2EZAoq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 20:44:46 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58962 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753279Ab2EZAoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 20:44:44 -0400
Message-ID: <4FC02777.5070003@fb.com>
Date: Fri, 25 May 2012 17:44:39 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <eric.dumazet@gmail.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: compute a more reasonable default ip6_rt_max_size
References: <4FC0063E.8080209@fb.com> <20120525.185131.2017517041016424794.davem@davemloft.net> <4FC01F1B.1080009@fb.com> <20120525.201150.1782581593120395710.davem@davemloft.net>
In-Reply-To: <20120525.201150.1782581593120395710.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7580,1.0.260,0.0.0000
 definitions=2012-05-25_06:2012-05-21,2012-05-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/12 5:11 PM, David Miller wrote:

>> These were not admin configured routes. They were discovered via ipv6
>> neighbor discovery.
>
> Then such default routes should either be:
>
> 1) Passed over by GC
>
> 2) Trigger neighbour discovery when GC'd

It's possible that there is a bug somewhere - we didn't get a chance to 
dig deeper. What we observed is that as we got close to the 4096 limit, 
some hosts were becoming unreachable. A modest increase in the routing 
table size made things better.

  -Arun
