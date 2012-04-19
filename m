Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab2DSI7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 04:59:21 -0400
Received: from szxga01-in.huawei.com ([58.251.152.64]:58225 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab2DSI7P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 04:59:15 -0400
Date: Thu, 19 Apr 2012 16:58:47 +0800
From: "Peter Huang(Peng)" <peter.huangpeng@huawei.com>
Subject: Re: [PATCH v3] set fake_rtable's dst to NULL to avoid kernel Oops.
In-reply-to: <20120418234649.0bcb3872@nehalam.linuxnetplumber.net>
X-Originating-IP: [10.166.90.111]
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: "'David S. Miller'" <davem@davemloft.net>, netdev@vger.kernel.org,
        ctrix+debianbugs@navynet.it, Eric Dumazet <eric.dumazet@gmail.com>,
        harry.majun@huawei.com, linux-kernel@vger.kernel.org,
        peter.huangpeng@gmail.com
Message-id: <4F8FD3C7.2030006@huawei.com>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7BIT
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:11.0) Gecko/20120327
 Thunderbird/11.0.1
X-CFilter-Loop: Reflected
References: <4F8F77F5.8020201@huawei.com>
 <20120418234649.0bcb3872@nehalam.linuxnetplumber.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/4/19 14:46, Stephen Hemminger wrote:
> On Thu, 19 Apr 2012 10:27:01 +0800
> "Peter Huang(Peng)"<peter.huangpeng@huawei.com>  wrote:
>
>> When bridge is deleted before tap/vif device's delete, kernel may
>> encounter an oops because of NULL reference to fake_rtable's dst.
>> Set fake_rtable's dst to NULL before sending packets out can solve this
>> problem.
>>
>> v3 enrich commit header
>>
>> v2 added a new flag DST_FAKE_RTABLE to dst_entry struct.
>>
>>
>> Acked-by: Eric Dumazet<eric.dumazet@gmail.com>
>> Signed-off-by: Peter Huang<peter.huangpeng@huawei.com>
>
> I am okay with the contents of the patch but the formatting is all
> botched. It adds bad indentation and whitespace, please run it
> through checkpatch.

Got it, I will send the v4 version of modified format.
Thanks!

