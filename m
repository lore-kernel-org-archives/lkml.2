Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab1KRHJl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 02:09:41 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:58678 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007Ab1KRHJk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 02:09:40 -0500
Date: Fri, 18 Nov 2011 02:09:21 -0500 (EST)
Message-Id: <20111118.020921.1221623749729939203.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: david.decotigny@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, ian.campbell@citrix.com,
        rick.jones2@hp.com
Subject: Re: [PATCH FIX net-next v1] net-forcedeth: fix possible stats
 inaccuracies on 32b hosts
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321560495.2444.1.camel@edumazet-laptop>
References: <cover.1321558587.git.david.decotigny@google.com>
	<34add86253ddd91d5d4d4c7fee9c90f63a8d8edf.1321558587.git.david.decotigny@google.com>
	<1321560495.2444.1.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Thu, 17 Nov 2011 23:09:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Thu, 17 Nov 2011 21:08:15 +0100

> Le jeudi 17 novembre 2011 à 11:38 -0800, David Decotigny a écrit :
>> The software stats are updated from BH, this change ensures that 32b
>> UP hosts use appropriate protection.
>> 
>> Tested:
>>   - HW/SW stats consistent with pktgen (in particular tx=rx)
>>   - HW/SW stats consistent when tx/rx offloads disabled
>>   - no problem with+without lockdep (SMP 16-way)
>> 
>> 
>> 
>> Signed-off-by: David Decotigny <david.decotigny@google.com>
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied, thanks.
