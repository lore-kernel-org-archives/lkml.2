Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755342Ab1CAFxd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:53:33 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:42847 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab1CAFxc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:53:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=rFLnK2D722UEhY4W75lZ40yqQ1L8skYhNFWXLttVKHzLqyFtQBXQj+MG3FlQijcnOc
         weRFFq7RrbcZMT1726FBdDEMzOTEY/wm3eAUeHdEGBY5eQ+c75EP0erA+9D/Vu8zJJjR
         bNBwbb+7m7G+1VM/I8GJzqiw2R2I8kYIXmma8=
Subject: Re: [PATCH ref0] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhutchings@solarflare.com,
        joe@perches.com, dilinger@queued.net, mirqus@gmail.com,
        ratbert@faraday-tech.com, Ajit Khaparde <ajit.khaparde@emulex.com>
In-Reply-To: <AANLkTi=MQoEKY5OLLN6f8-N7eD--Q6hL99HFFTAGU_Y4@mail.gmail.com>
References: <AANLkTikXUyQy+fjFSwagB3Uud2JPodsR2yFtt+jiZPSk@mail.gmail.com>
	 <AANLkTikmqQfT1s2Z6J+KYmqi0CuCc4+2k67eeb4ydtCM@mail.gmail.com>
	 <1298631127.2659.22.camel@edumazet-laptop>
	 <20110225.103456.226779149.davem@davemloft.net>
	 <1298659538.2659.103.camel@edumazet-laptop>
	 <1298659663.2659.104.camel@edumazet-laptop>
	 <AANLkTi=MQoEKY5OLLN6f8-N7eD--Q6hL99HFFTAGU_Y4@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 06:53:26 +0100
Message-ID: <1298958806.2676.27.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 01 mars 2011 à 13:45 +0800, Po-Yu Chuang a écrit :
> Hi Eric,
> 
> On Sat, Feb 26, 2011 at 2:47 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:

> >
> > A compromise would be to use 128 for the allocation, but only copy 64
> > bytes.
> 
> I will use this way and submit v7 later.
> 

BTW, even with IPV6, the first 64 bytes contain "RPS" header

We changed NET_SKB_PAD a while back and added this comment in
include/linux/skbuff.h

NET_IP_ALIGN(2) + ethernet_header(14) + IP_header(20/40) + ports(8)


