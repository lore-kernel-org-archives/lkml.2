Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab2A3ThH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 14:37:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:29642 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752327Ab2A3ThF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 14:37:05 -0500
Message-ID: <4F26F15C.9080808@redhat.com>
Date: Mon, 30 Jan 2012 20:37:00 +0100
From: Denys Vlasenko <dvlasenk@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Deinline __nlmsg_put and genlmsg_put. -7k code on i386
 defconfig
References: <4F2597D3.6050606@redhat.com> <20120130.131104.1782962680660646529.davem@davemloft.net>
In-Reply-To: <20120130.131104.1782962680660646529.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 07:11 PM, David Miller wrote:
> This doesn't apply to net-next, it appears it was corrupted by your
> email client:
>
>> -static __inline__ struct nlmsghdr *
>> -__nlmsg_put(struct sk_buff *skb, u32 pid, u32 seq, int type, int len,
>> -int flags)
>
> It appears to have chopped up a long line here, for example.

I rediffed the patch against net-next, compile-tested it and going
to send it using git-send-email in a minute.

-- 
vda
