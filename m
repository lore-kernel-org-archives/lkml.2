Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758885Ab2EYWXR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:23:17 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:34149 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758655Ab2EYWXA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:23:00 -0400
Message-ID: <4FC0063E.8080209@fb.com>
Date: Fri, 25 May 2012 15:22:54 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] net: compute a more reasonable default ip6_rt_max_size
References: <1337976934-18065-1-git-send-email-asharma@fb.com> <1337978820.10135.1.camel@edumazet-glaptop>
In-Reply-To: <1337978820.10135.1.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7580,1.0.260,0.0.0000
 definitions=2012-05-25_06:2012-05-21,2012-05-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/12 1:47 PM, Eric Dumazet wrote:
> On Fri, 2012-05-25 at 13:15 -0700, Arun Sharma wrote:
>> The algorithm is based on ipv4 and alloc_large_system_hash().
>>
>
> Why is it needed at all ?
>
> IPv4 has a route cache with potentially millions of entries, not IPv6.

With the default size of 4096 for the ipv6 routing table, entries can 
get garbage collected and hosts could lose their default route and 
therefore lose connectivity.

We actually saw it happen.

  -Arun


