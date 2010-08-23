Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753238Ab0HWEPu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 00:15:50 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:34964
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752797Ab0HWEPs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 00:15:48 -0400
Date: Sun, 22 Aug 2010 21:16:05 -0700 (PDT)
Message-Id: <20100822.211605.02288279.davem@davemloft.net>
To: xiaosuo@gmail.com
Cc: arnd@arndb.de, eric.dumazet@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: define __packed for the userspace code
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100822.193609.35028164.davem@davemloft.net>
References: <20100822.183624.28802617.davem@davemloft.net>
	<AANLkTikBcuYa_HNzhYYG62CLjcfptQNQM_zOsv9fXRfS@mail.gmail.com>
	<20100822.193609.35028164.davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Sun, 22 Aug 2010 19:36:09 -0700 (PDT)

> From: Changli Gao <xiaosuo@gmail.com>
> Date: Mon, 23 Aug 2010 10:29:49 +0800
> 
>> Do you mean that use the __attribute__((packed)) annotation in all of
>> these files:
>> 
>> localhost linux # grep "\<__packed\>" usr/include/ -r | uniq
>> usr/include/linux/if_hippi.h:} __packed;
>> usr/include/linux/if_fddi.h:} __packed;
>> usr/include/linux/nbd.h:} __packed;
>> usr/include/linux/ncp.h:} __packed;
>> usr/include/linux/rfkill.h:} __packed;
>> usr/include/linux/if_pppox.h:} __packed;
>> usr/include/linux/phonet.h:} __packed;
>> usr/include/linux/ipv6.h:} __packed;    /* required for some archs */
>> usr/include/linux/ipv6.h:} __packed;
>> usr/include/linux/if_ether.h:} __packed;
> 
> It seems so, yes.

Changli I applied your patch to convert these __packed tags back to
the original expansion.

Thanks!
