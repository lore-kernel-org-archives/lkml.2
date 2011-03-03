Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758756Ab1CCUSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 15:18:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42998
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752492Ab1CCUSx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 15:18:53 -0500
Date: Thu, 03 Mar 2011 12:19:30 -0800 (PST)
Message-Id: <20110303.121930.102558466.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: ratbert.chuang@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhutchings@solarflare.com,
        joe@perches.com, dilinger@queued.net, mirqus@gmail.com,
        ratbert@faraday-tech.com
Subject: Re: [PATCH] net: add Faraday FTMAC100 10/100 Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1298964420.2676.59.camel@edumazet-laptop>
References: <1298627845-1583-1-git-send-email-ratbert.chuang@gmail.com>
	<1298962129-1605-1-git-send-email-ratbert.chuang@gmail.com>
	<1298964420.2676.59.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 01 Mar 2011 08:27:00 +0100

> Le mardi 01 mars 2011 à 14:48 +0800, Po-Yu Chuang a écrit :
>> From: Po-Yu Chuang <ratbert@faraday-tech.com>
>> 
>> FTMAC100 Ethernet Media Access Controller supports 10/100 Mbps and
>> MII.  This driver has been working on some ARM/NDS32 SoC's including
>> Faraday A320 and Andes AG101.
>> 
>> Signed-off-by: Po-Yu Chuang <ratbert@faraday-tech.com>
 ...
> 
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>

Applied to net-next-2.6, thanks.
