Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932654Ab1BYSry (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 13:47:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54511 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab1BYSrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 13:47:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=o52iyCo+R4BGDu6E5Sw+8frkqKDLRqNvGnWaZeJeUycVA+L/gYTNRuVqgQL1pHaOTR
         pgUqrIw16mXVTGuf2jGQ5FDGSgnPCvvhTz95Wu6R2WL9c6cgvMowgWc6uhcI62DEzX8g
         8lyExQGOgJF3eoRnVSdesHLzTNmAu4tEzE+c8=
Subject: Re: [PATCH ref0] net: add Faraday FTMAC100 10/100 Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: ratbert.chuang@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhutchings@solarflare.com,
        joe@perches.com, dilinger@queued.net, mirqus@gmail.com,
        ratbert@faraday-tech.com, Ajit Khaparde <ajit.khaparde@emulex.com>
In-Reply-To: <1298659538.2659.103.camel@edumazet-laptop>
References: <AANLkTikXUyQy+fjFSwagB3Uud2JPodsR2yFtt+jiZPSk@mail.gmail.com>
	 <AANLkTikmqQfT1s2Z6J+KYmqi0CuCc4+2k67eeb4ydtCM@mail.gmail.com>
	 <1298631127.2659.22.camel@edumazet-laptop>
	 <20110225.103456.226779149.davem@davemloft.net>
	 <1298659538.2659.103.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Feb 2011 19:47:43 +0100
Message-ID: <1298659663.2659.104.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 25 février 2011 à 19:45 +0100, Eric Dumazet a écrit :
> Le vendredi 25 février 2011 à 10:34 -0800, David Miller a écrit :
> > From: Eric Dumazet <eric.dumazet@gmail.com>
> > Date: Fri, 25 Feb 2011 11:52:07 +0100
> > 
> > > Le vendredi 25 février 2011 à 17:45 +0800, Po-Yu Chuang a écrit :
> > > 
> > >> It's a little faster than v5 now. Thanks.
> > >> I will submit the current version later.
> > >> 
> > >> One more question just curious, why 128 bytes?
> > > 
> > > Probably its best for NIU hardware specs
> > > 
> > > You could try 64, as it should be enough for most IP/TCP/UDP processing.
> > 
> > IPV6.
> 
> drivers/net/benet/be.h:70:#define BE_HDR_LEN            64
> 
> Maybe we should have a comment somewhere.
> 
> CC Ajit Khaparde <ajit.khaparde@emulex.com>
> 


A compromise would be to use 128 for the allocation, but only copy 64
bytes.



