Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab2EZLWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 May 2012 07:22:34 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:55602 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752992Ab2EZLWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 May 2012 07:22:12 -0400
X-Sasl-enc: 63Te05+4E21r9Esvq/rFU7UYmv0vA7Ey9YJonrMUFJyp 1338031331
Message-ID: <4FC0BCE1.6070601@fastmail.fm>
Date: Sat, 26 May 2012 12:22:09 +0100
From: Jack Stone <jwjstone@fastmail.fm>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: davem@davemloft.net, netdev@vger.kernel.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: at net/ipv4/tcp.c:1610 tcp_recvmsg+0xb1b/0xc70()
References: <4FBFEACC.8040601@fastmail.fm>  <1337978725.10135.0.camel@edumazet-glaptop> <1337979331.10135.2.camel@edumazet-glaptop>
In-Reply-To: <1337979331.10135.2.camel@edumazet-glaptop>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/2012 09:55 PM, Eric Dumazet wrote:
> On Fri, 2012-05-25 at 22:45 +0200, Eric Dumazet wrote:
>> On Fri, 2012-05-25 at 21:25 +0100, Jack Stone wrote:
>>> Hi All,
>>>
>>> The following warning keeps hitting me. I couldn't get the first one - it had already left dmesg hence the W taint.
>>> The C taint is from r8712u from staging.
>>>
>>> I've seen it with 3.4.0-076444-g07acfc2 (recent Linus tree) and 3.4.0-rc3-00089-gc6f5c93.
>>>
>>> I am going to attempt to bisect it now.
>>
>> No need, update your tree.
>>
>>
> 
> 
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=1ca7ee30630e1022dbcf1b51be20580815ffab73
> 
> 
> 

I'm still getting this with da89fb1 which includes the above

Linux hover1 3.4.0-07797-gda89fb1 #4 SMP Fri May 25 22:23:14 BST 2012 x86_64 x86_64 x86_64 GNU/Linux
