Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756333Ab1CSPwT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 11:52:19 -0400
Received: from 3.27.mail-out.ovh.net ([46.105.56.209]:42017 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1753391Ab1CSPwR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 11:52:17 -0400
Message-ID: <4D84D123.8060903@example.com>
Date: Sat, 19 Mar 2011 16:52:03 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Oliver Neukum <oliver@neukum.org>
CC: Eric Dumazet <eric.dumazet@gmail.com>,
        Anca Emanuel <anca.emanuel@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Francois Romieu <romieu@fr.zoreil.com>,
        David Miller <davem@davemloft.net>
Subject: Re: [PATCH] r8169: fix a bug in rtl8169_init_phy()
References: <4D84A46B.1000407@example.com> <1300548821.2831.28.camel@edumazet-laptop> <1300549151.2831.32.camel@edumazet-laptop> <201103191641.41718.oliver@neukum.org>
In-Reply-To: <201103191641.41718.oliver@neukum.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 15070451730189873501
X-Ovh-Remote: 178.36.62.164 (178-36-62-164.adsl.inetia.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.03.2011 16:41, Oliver Neukum wrote:
> Am Samstag, 19. März 2011, 16:39:11 schrieben Sie:
>> Le samedi 19 mars 2011 à 16:33 +0100, Eric Dumazet a écrit :
>>> Le samedi 19 mars 2011 à 16:31 +0100, Oliver Neukum a écrit :
>>>> Am Samstag, 19. März 2011, 16:18:50 schrieb Eric Dumazet:
>>>>
>>>>> Problem comes from commit 54405cde762408b00a445466a40da4f7f33a8479
>>>>> (r8169: support control of advertising.)
>>>>>
>>>>> Reverting it brings back NIC for me
>>>>
>>>> Odd. It worked for me. Are you testing on a gigabit switch? Could you send
>>>> me dmesg? Does it work if you use ethtool to advertise a lower speed?
>>>>
>>>> 	Regards
>>>> 		Oliver
>>>
>>> I found the bug, I am sending a patch in two minutes.
>>>
>>
>> Here it is
>>
>> [PATCH] r8169: fix a bug in rtl8169_init_phy()
>>
>> commit 54405cde7624 (r8169: support control of advertising.)
>> introduced a bug in rtl8169_init_phy()
>
> Thank you. I feel like banging my head against something.

If it will work I will be banging against the wall. I am missing for a 
fresh new kernel with networking.

-- 
Szef TVN24 do dziennikarzy: Kochani, przez dwa lata waliliśmy w obóz
rządzący. Tak dalej byc nie może. Jesteśmy telewizją niezależną i to
zobowiązuje. Teraz będziemy kopać w opozycję.
NP: Big Big Train - Victorian Brickwork
NB: 2.6.38-git3
