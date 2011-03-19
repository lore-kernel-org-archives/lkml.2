Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756796Ab1CSQ1O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 12:27:14 -0400
Received: from 4.27.mail-out.ovh.net ([46.105.52.239]:55007 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1756497Ab1CSQ1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 12:27:12 -0400
Message-ID: <4D84D956.8090407@example.com>
Date: Sat, 19 Mar 2011 17:27:02 +0100
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
References: <4D84A46B.1000407@example.com>	 <AANLkTimFGeHYEOxx=h883rRJL463g1CBUDS0wGM-52Nj@mail.gmail.com>	 <1300547930.2831.27.camel@edumazet-laptop>	 <201103191631.07952.oliver@neukum.org>	 <1300548821.2831.28.camel@edumazet-laptop>	 <1300549151.2831.32.camel@edumazet-laptop>  <4D84D098.1050802@example.com> <1300550653.2831.34.camel@edumazet-laptop>
In-Reply-To: <1300550653.2831.34.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 15660986230990008771
X-Ovh-Remote: 178.36.62.164 (178-36-62-164.adsl.inetia.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.03.2011 17:04, Eric Dumazet wrote:
> Le samedi 19 mars 2011 à 16:49 +0100, Piotr Hosowicz a écrit :
>
>> I do not understand. I reverted the commit you mentioned and am building
>> now. Will it suffice?
>>
>
> Either you
>
> 1) Revert the commit

OK. This is what I've done and everything is OK, net works as usual. But 
what should I do next? Will the revert be done on the GIT server? And 
when? I try not to clone to much and wastefuly. And am new to GIT so 
sorry for the question.

>
> OR
>
> 2) apply my patch

Regards and thanks,

Piotr Hosowicz

-- 
Jest jedna korzyść z posiadania TV - jak dobrze
rozregulujesz odbiornik, trafisz na promieniowanie
mikrofalowe z początków Wszechświata.
NP: Big Big Train - Master James Of St George
NB: 2.6.38-20110319-1638-net+
