Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755323Ab1CAFpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 00:45:53 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42011 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755200Ab1CAFpu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 00:45:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FA1t4G7LjAAqseBB3e5IdXgUKGHQRSIoO8JReGjnfjMmslW5latmnmmhFIZRJuG4zr
         nbirYf6KBiWaG2qC7XunZXyiTICP+cLiaeRcR3Ws0dAu/D/aCR6F0u29EzWGKRwDlWZe
         1DM8BnK6EBEcNuv7yMAAU6CXFxnq9bwKhXsIQ=
MIME-Version: 1.0
In-Reply-To: <1298659663.2659.104.camel@edumazet-laptop>
References: <AANLkTikXUyQy+fjFSwagB3Uud2JPodsR2yFtt+jiZPSk@mail.gmail.com>
 <AANLkTikmqQfT1s2Z6J+KYmqi0CuCc4+2k67eeb4ydtCM@mail.gmail.com>
 <1298631127.2659.22.camel@edumazet-laptop> <20110225.103456.226779149.davem@davemloft.net>
 <1298659538.2659.103.camel@edumazet-laptop> <1298659663.2659.104.camel@edumazet-laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Tue, 1 Mar 2011 13:45:29 +0800
Message-ID: <AANLkTi=MQoEKY5OLLN6f8-N7eD--Q6hL99HFFTAGU_Y4@mail.gmail.com>
Subject: Re: [PATCH ref0] net: add Faraday FTMAC100 10/100 Ethernet driver
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bhutchings@solarflare.com,
        joe@perches.com, dilinger@queued.net, mirqus@gmail.com,
        ratbert@faraday-tech.com, Ajit Khaparde <ajit.khaparde@emulex.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Sat, Feb 26, 2011 at 2:47 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le vendredi 25 février 2011 à 19:45 +0100, Eric Dumazet a écrit :
>> Le vendredi 25 février 2011 à 10:34 -0800, David Miller a écrit :
>> > From: Eric Dumazet <eric.dumazet@gmail.com>
>> > Date: Fri, 25 Feb 2011 11:52:07 +0100
>> >
>> > > Le vendredi 25 février 2011 à 17:45 +0800, Po-Yu Chuang a écrit :
>> > >
>> > >> It's a little faster than v5 now. Thanks.
>> > >> I will submit the current version later.
>> > >>
>> > >> One more question just curious, why 128 bytes?
>> > >
>> > > Probably its best for NIU hardware specs
>> > >
>> > > You could try 64, as it should be enough for most IP/TCP/UDP processing.
>> >
>> > IPV6.
>>
>> drivers/net/benet/be.h:70:#define BE_HDR_LEN            64
>>
>> Maybe we should have a comment somewhere.
>>
>> CC Ajit Khaparde <ajit.khaparde@emulex.com>
>>
>
>
> A compromise would be to use 128 for the allocation, but only copy 64
> bytes.

I will use this way and submit v7 later.

Thanks,
Po-Yu Chuang
