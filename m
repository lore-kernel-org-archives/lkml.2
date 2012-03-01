Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab2CAQCQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 11:02:16 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50004 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753545Ab2CAQCO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 11:02:14 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of luiz.dentz@gmail.com designates 10.236.161.201 as permitted sender) smtp.mail=luiz.dentz@gmail.com; dkim=pass header.i=luiz.dentz@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F4F7FFB.6010608@collabora.co.uk>
References: <AE90C24D6B3A694183C094C60CF0A2F6026B6E86@saturn3.aculab.com>
	<1330606237.27405.5.camel@megeve>
	<1330606775.2465.56.camel@edumazet-laptop>
	<4F4F7FFB.6010608@collabora.co.uk>
Date: Thu, 1 Mar 2012 18:02:14 +0200
Message-ID: <CABBYNZKN+7z4Sr9DBniokez6Jru02LxPgWdGNcVeYECse+AzEQ@mail.gmail.com>
Subject: Re: [PATCH 0/10] af_unix: add multicast and filtering features to AF_UNIX
From: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Rodrigo Moya <rodrigo.moya@collabora.co.uk>,
        David Laight <David.Laight@aculab.com>,
        David Miller <davem@davemloft.net>, javier@collabora.co.uk,
        lennart@poettering.net, kay.sievers@vrfy.org,
        alban.crequy@collabora.co.uk, bart.cerneels@collabora.co.uk,
        sjoerd.simons@collabora.co.uk, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Javier,

On Thu, Mar 1, 2012 at 3:56 PM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
>>
>> Anyway, if you think multicast sockets is the way to go, then you could
>> setup a virtual network just to be able to use AF_INET multicast.
>>
>> Thats probably doable without kernel patching.
>>
>
> We could use AF_INET multicast on a local machine but we need some
> ordering and control flow requirements that are not guaranteed on UDP
> multicast over IP. That's why we thought to add a new address family
> AF_MCAST.

I don't want to sound like a broken record, but Im afraid I have to,
what about Ancillary Messages, how you are going to support passing
fd? Actually the whole virtual network sounds like a bad idea, are we
going to give ips to each and every application connected to the bus,
actually it is necessary to have one virtual network for each bus.

Contrary to someones believes I don't think AF_INET is that fast (e.g.
http://scottmoonen.com/2008/04/05/a-performance-comparison-of-af_unix-with-loopback-on-linux/)


-- 
Luiz Augusto von Dentz
