Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab0JKSMR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 14:12:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:47179
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755828Ab0JKSMP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 14:12:15 -0400
Date: Mon, 11 Oct 2010 11:12:36 -0700 (PDT)
Message-Id: <20101011.111236.183050557.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: jslaby@suse.cz, netdev@vger.kernel.org,
        linux-atm-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, chas@cmf.nrl.navy.mil
Subject: Re: [PATCH 1/1] ATM: solos-pci, remove use after free
From: David Miller <davem@davemloft.net>
In-Reply-To: <1286785169.2737.3.camel@edumazet-laptop>
References: <1286783444-7719-1-git-send-email-jslaby@suse.cz>
	<1286785169.2737.3.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Mon, 11 Oct 2010 10:19:29 +0200

> Le lundi 11 octobre 2010 à 09:50 +0200, Jiri Slaby a écrit :
>> Stanse found we do in console_show:
>>   kfree_skb(skb);
>>   return skb->len;
>> which is not good. Fix that by remembering the len and use it in the
>> function instead.
>> 
>> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
>> Cc: Chas Williams <chas@cmf.nrl.navy.mil>
>> ---
> 
> Acked-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied.
