Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab2DRIo7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 04:44:59 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:35492 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab2DRIo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 04:44:57 -0400
Date: Wed, 18 Apr 2012 04:41:57 -0400 (EDT)
Message-Id: <20120418.044157.1410691335536408716.davem@davemloft.net>
To: peter.huangpeng@huawei.com
Cc: eric.dumazet@gmail.com, shemminger@vyatta.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ctrix+debianbugs@navynet.it,
        peter.huangpeng@gmail.com, harry.majun@huawei.com
Subject: Re: [PATCH] set fake_rtable's dst to NULL to avoid kernel Oops.
From: David Miller <davem@davemloft.net>
In-Reply-To: <4F8E73E3.6080900@huawei.com>
References: <20120417085248.3e642294@nehalam.linuxnetplumber.net>
	<1334681323.2472.43.camel@edumazet-glaptop>
	<4F8E73E3.6080900@huawei.com>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Wed, 18 Apr 2012 01:42:01 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Peter Huang(Peng)" <peter.huangpeng@huawei.com>
Date: Wed, 18 Apr 2012 15:57:23 +0800

> On 2012/4/18 0:48, Eric Dumazet wrote:
>> On Tue, 2012-04-17 at 08:52 -0700, Stephen Hemminger wrote:
>>
>>> This check seems like a disaster waiting to happen when the next
>>> change to DST table happens.
>>
>> Please Peter Document this, adding a new DST_FAKE_RTABLE flag
>>
>> #define DST_FAKE_RTABLE DST_NOPEER
>>
>> or just use a bit, we have plenty of them available.
>>
> 
> 
> Add DST_FAKE_RTABLE to dst_entry, this is the new patch.
> Is this ok?
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Peter Huang <peter.huangpeng@huawei.com>

Please post new patches as completely new emails, not as replies
to other emails.
