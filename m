Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427Ab1BYSeV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:34:21 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:43336
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753474Ab1BYSeU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:34:20 -0500
Date: Fri, 25 Feb 2011 10:34:56 -0800 (PST)
Message-Id: <20110225.103456.226779149.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: ratbert.chuang@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhutchings@solarflare.com,
        joe@perches.com, dilinger@queued.net, mirqus@gmail.com,
        ratbert@faraday-tech.com
Subject: Re: [PATCH ref0] net: add Faraday FTMAC100 10/100 Ethernet driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1298631127.2659.22.camel@edumazet-laptop>
References: <AANLkTikXUyQy+fjFSwagB3Uud2JPodsR2yFtt+jiZPSk@mail.gmail.com>
	<AANLkTikmqQfT1s2Z6J+KYmqi0CuCc4+2k67eeb4ydtCM@mail.gmail.com>
	<1298631127.2659.22.camel@edumazet-laptop>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Fri, 25 Feb 2011 11:52:07 +0100

> Le vendredi 25 février 2011 à 17:45 +0800, Po-Yu Chuang a écrit :
> 
>> It's a little faster than v5 now. Thanks.
>> I will submit the current version later.
>> 
>> One more question just curious, why 128 bytes?
> 
> Probably its best for NIU hardware specs
> 
> You could try 64, as it should be enough for most IP/TCP/UDP processing.

IPV6.
