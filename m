Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab2EHREV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 13:04:21 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59586 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757462Ab2EHREU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 13:04:20 -0400
Date: Tue, 08 May 2012 13:01:39 -0400 (EDT)
Message-Id: <20120508.130139.515602646900287732.davem@davemloft.net>
To: greearb@candelatech.com
Cc: cristian.chilipirea@gmail.com, kuznet@ms2.inr.ac.ru, jmorris@namei.org,
        yoshfuji@linux-ipv6.org, kaber@trash.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, daniel.baluta@gmail.com
Subject: Re: [PATCH] ipv4: Fixed checkpatch warnings and errors
From: David Miller <davem@davemloft.net>
In-Reply-To: <4FA9382A.9090709@candelatech.com>
References: <1336474704-9366-1-git-send-email-cristian.chilipirea@gmail.com>
	<4FA9382A.9090709@candelatech.com>
X-Mailer: Mew version 6.5 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 08 May 2012 10:01:41 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Greear <greearb@candelatech.com>
Date: Tue, 08 May 2012 08:13:46 -0700

> On 05/08/2012 03:58 AM, Cristian Chilipirea wrote:
>> Fixed warnings and errors in af_inet.c.
> 
>>   #ifdef CONFIG_COMPAT
>> -static int inet_compat_ioctl(struct socket *sock, unsigned int cmd,
>> -unsigned long arg)
>> +static int inet_compat_ioctl(struct socket *sock, unsigned int cmd,
>> +		unsigned long arg)
>>   {
> 
> That is so much worse than what was there before.
> 
> Lets stop useless checkpatch crap on existing code
> unless it's really ugly.

Agreed, this patch is terrible.
