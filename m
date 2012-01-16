Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755084Ab2APPU2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 10:20:28 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44241 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754637Ab2APPU0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 10:20:26 -0500
MIME-Version: 1.0
In-Reply-To: <1326726817.2255.52.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
References: <CAGsizzJTbGGpwrn-P=SUtqBW=1AN6hCTVXKp_oKHPBAoGZ4ubA@mail.gmail.com>
 <1326719999.2255.27.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CAGsizzJpdF5xzsEiZd5R0GD8r7pDJyz4ro=4vLBnonxfAVYg-Q@mail.gmail.com>
 <1326723932.2255.41.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <CAGsizz+LEPJEGhMEHgswFJL4=Mh9R8g9FX6BcjqH0LBp2MUg0Q@mail.gmail.com> <1326726817.2255.52.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
From: =?ISO-8859-2?Q?=A9tefan_Gula?= <steweg@gmail.com>
Date: Mon, 16 Jan 2012 16:20:05 +0100
Message-ID: <CAGsizzKrY8OseQY=am4q=0fuNGHf9ff59pO4NvLvJfzHpYuXNg@mail.gmail.com>
Subject: Re: [patch v1, kernel version 3.2.1] net/ipv4/ip_gre: Ethernet
 multipoint GRE over IP
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        "David S. Miller" <davem@davemloft.net>,
        James Morris <jmorris@namei.org>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Patrick McHardy <kaber@trash.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dňa 16. januára 2012 16:13, Eric Dumazet <eric.dumazet@gmail.com> napísal/a:
> Le lundi 16 janvier 2012 à 15:47 +0100, Štefan Gula a écrit :
>
>> File: net/birdge/br_fdb.c
>> Functions:
>> __br_fdb_get
>> br_fdb_get
>> My analogy fuctions:
>> __ipgre_tap_bridge_get
>> ipgre_tap_bridge_get
>>
>
> There is no br_fdb_get(), you copied some buggy code I am afraid.
>
> Read again your patch.
>
> If you use atomic_inc_not_zero(&x->use_count), then you must do the
> atomic_dec() or leak entries.
>
> Current bridge code doesnt use atomic_inc_not_zero()
>
>
>
You are right, new bridge code doesn't have such function, I will adjust that
