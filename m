Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab0JKSNF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 14:13:05 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47198
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756053Ab0JKSNB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 14:13:01 -0400
Date: Mon, 11 Oct 2010 11:13:23 -0700 (PDT)
Message-Id: <20101011.111323.115931626.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: jslaby@suse.cz, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, masa-korg@dsn.okisemi.com
Subject: Re: [PATCH 1/3] NET: pch, fix use after free
From: David Miller <davem@davemloft.net>
In-Reply-To: <1286789918.2737.8.camel@edumazet-laptop>
References: <1286789218-13976-1-git-send-email-jslaby@suse.cz>
	<1286789918.2737.8.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 11 Oct 2010 11:38:38 +0200

> Le lundi 11 octobre 2010 à 11:26 +0200, Jiri Slaby a écrit :
>> Stanse found that pch_gbe_xmit_frame uses skb after it is freed. Fix
>> that.
>> 
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Cc: Masayuki Ohtake <masa-korg@dsn.okisemi.com>
>> ---
>>  drivers/net/pch_gbe/pch_gbe_main.c |    2 +-
>>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> Applicable to net-next-2.6 only, this driver is not yet in Linus tree
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

I'll apply this to net-next-2.6, thanks.
