Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752458Ab2E0Dyk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 23:54:40 -0400
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:42521 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750816Ab2E0Dyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 23:54:36 -0400
Message-ID: <4FC1A57A.7080807@fb.com>
Date: Sat, 26 May 2012 20:54:34 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] net: compute a more reasonable default ip6_rt_max_size
References: <4FC0063E.8080209@fb.com>  <20120525.185131.2017517041016424794.davem@davemloft.net>  <4FC01F1B.1080009@fb.com>  <20120525.201150.1782581593120395710.davem@davemloft.net>  <4FC02777.5070003@fb.com> <1338003580.10135.6.camel@edumazet-glaptop>
In-Reply-To: <1338003580.10135.6.camel@edumazet-glaptop>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7580,1.0.260,0.0.0000
 definitions=2012-05-27_01:2012-05-21,2012-05-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/25/12 8:39 PM, Eric Dumazet wrote:
>
> But your patch is not a  "modest increase", so whats the deal ?
>
> A modest increase would be 8192 instead of 4096, regardless of RAM size.
>

Yes - 8192 solves our immediate problem, but I was worrying that the 
problem might resurface as ipv6 adoption becomes more widespread.

We were testing a pre-3.0 kernel that didn't have Dave's DST_NOCOUNT 
patch. Will retest with that patch applied.

 > More over, a boot parameter to tweak it is absolutely not needed

Agreed. Will remove that part.

Still not sure why you'd like to go for one size regardless of 
totalram_pages.

  -Arun
