Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753056Ab0I3C14 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 22:27:56 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50476
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752636Ab0I3C1z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 22:27:55 -0400
Date: Wed, 29 Sep 2010 19:28:16 -0700 (PDT)
Message-Id: <20100929.192816.116374275.davem@davemloft.net>
To: torvalds@linux-foundation.org
Cc: bharrosh@panasas.com, akpm@linux-foundation.org, julia@diku.dk,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH] um: Proper Fix for f25c80a4: remove duplicate
 structure field initialization
From: David Miller <davem@davemloft.net>
In-Reply-To: <AANLkTikX1xWiZ+XROF=CEvkE+BVpv6vk5vzW2BGt-bxq@mail.gmail.com>
References: <AANLkTi=E7+CpJZE3XC7O1LvJu6LWfmvSxonskH4CYg25@mail.gmail.com>
	<4CA2FA13.8050405@panasas.com>
	<AANLkTikX1xWiZ+XROF=CEvkE+BVpv6vk5vzW2BGt-bxq@mail.gmail.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 29 Sep 2010 08:05:04 -0700

> On Wed, Sep 29, 2010 at 1:34 AM, Boaz Harrosh <bharrosh@panasas.com> wrote:
>>
>> On the other hand patch [f25c80a4] was trying to use eth_mac_addr()
>> in eth_configure(), *which was the real fallout*. Because of state
>> checks done inside eth_mac_addr() the address was never set. I have
>> not reintroduced the memcpy wrapper, but I've put a comment for future
>> cats.
> 
> Ahh. Ok, this looks fine. David, please use this instead of my broken
> one that didn't do the whole thing.

Oops, I just noticed this, ok will do.
