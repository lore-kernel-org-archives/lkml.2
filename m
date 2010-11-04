Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754834Ab0KDByc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 21:54:32 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45554
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754389Ab0KDBy3 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 21:54:29 -0400
Date: Wed, 03 Nov 2010 18:54:52 -0700 (PDT)
Message-Id: <20101103.185452.39170079.davem@davemloft.net>
To: teg@jklm.no
Cc: eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: panic with 2.6.37-rc1
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTimY+cC=bu6LDb_e-Qbghd-F0RNZejhKaeXJWbY7@mail.gmail.com>
References: <AANLkTi=mEzCMCC+K6oLOjW9xfws_+_hHq8DS3hpPB1zY@mail.gmail.com>
	<1288822281.2718.30.camel@edumazet-laptop>
	<AANLkTimY+cC=bu6LDb_e-Qbghd-F0RNZejhKaeXJWbY7@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tom Gundersen <teg@jklm.no>
Date: Wed, 3 Nov 2010 23:42:02 +0100

> On Wed, Nov 3, 2010 at 11:11 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>> Le mercredi 03 novembre 2010 à 23:02 +0100, Tom Gundersen a écrit :
>>> I get panic during boot both with 2.6.37-rc1 and with current head.
>>>
>>> Here is the error message:
>>> <http://www.lix.polytechnique.fr/~tom/2.6.37-rc1-panic.jpg>. My
>>> .config is below.
>>>
>>> Let me know if you want more info. If you want I can test patches or
>>> bisect (if no one has any better suggestions).
>>>
>>
>> Please test following patch, thanks
>>
>> [PATCH] atl1 : fix panic on load
>>
>> Its now illegal to call netif_stop_queue() before register_netdev()
>>
>> Reported-by: Tom Gundersen <teg@jklm.no>
>> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
 ...
> The patch solves the problem. Thanks!

Applied, thanks everyone.
