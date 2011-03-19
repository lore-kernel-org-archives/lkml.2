Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757337Ab1CSS7O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 14:59:14 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:60310 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757241Ab1CSS7M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 14:59:12 -0400
Message-ID: <4D84FCF9.8010801@example.com>
Date: Sat, 19 Mar 2011 19:59:05 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Oliver Neukum <oliver@neukum.org>, Anca Emanuel <anca.emanuel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Francois Romieu <romieu@fr.zoreil.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] r8169: fix a bug in rtl8169_init_phy()
References: <4D84A46B.1000407@example.com>	 <AANLkTimFGeHYEOxx=h883rRJL463g1CBUDS0wGM-52Nj@mail.gmail.com>	 <1300547930.2831.27.camel@edumazet-laptop>	 <201103191631.07952.oliver@neukum.org>	 <1300548821.2831.28.camel@edumazet-laptop> <1300549151.2831.32.camel@edumazet-laptop>
In-Reply-To: <1300549151.2831.32.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 18229163918139814339
X-Ovh-Remote: 178.36.141.241 (178-36-141-241.adsl.inetia.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.03.2011 16:39, Eric Dumazet wrote:
> Le samedi 19 mars 2011 à 16:33 +0100, Eric Dumazet a écrit :
>> Le samedi 19 mars 2011 à 16:31 +0100, Oliver Neukum a écrit :
>>> Am Samstag, 19. März 2011, 16:18:50 schrieb Eric Dumazet:
>>>
>>>> Problem comes from commit 54405cde762408b00a445466a40da4f7f33a8479
>>>> (r8169: support control of advertising.)
>>>>
>>>> Reverting it brings back NIC for me
>>>
>>> Odd. It worked for me. Are you testing on a gigabit switch? Could you send
>>> me dmesg? Does it work if you use ethtool to advertise a lower speed?
>>>
>>> 	Regards
>>> 		Oliver
>>
>> I found the bug, I am sending a patch in two minutes.
>>
>
> Here it is
>
> [PATCH] r8169: fix a bug in rtl8169_init_phy()
>
> commit 54405cde7624 (r8169: support control of advertising.)
> introduced a bug in rtl8169_init_phy()
>
> Reported-by: Piotr Hosowicz<piotr@hosowicz.com>
> Signed-off-by: Eric Dumazet<eric.dumazet@gmail.com>
> Cc: Oliver Neukum<oliver@neukum.org>
> Cc: Francois Romieu<romieu@fr.zoreil.com>

Tested-by: Piotr Hosowicz<piotr@hosowicz.com>

Works OK now.

Regards,

Piotr Hosowicz

-- 
Parafrazując Einsteina: w socjaliźmie są dwa zawody z przy-
szłością: piekarz i urzędnik, chociaż co do pierwszego to
nie mam pewności. (by Kubarek, http://blog.kubarek.info/)
NP: Karmakanic - Send a message from the heart
NB: 2.6.38-20110319-1638-net++
