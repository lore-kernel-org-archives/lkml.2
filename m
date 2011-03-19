Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab1CSNFF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 09:05:05 -0400
Received: from 2.26.mail-out.ovh.net ([178.33.107.8]:32782 "HELO
	26.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1751451Ab1CSNE7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 09:04:59 -0400
X-Greylist: delayed 155329 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Mar 2011 09:04:59 EDT
Message-ID: <4D84A9F6.8080402@example.com>
Date: Sat, 19 Mar 2011 14:04:54 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: Anca Emanuel <anca.emanuel@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: No networking since git3
References: <4D84A46B.1000407@example.com> <AANLkTi=qrK2L+MA5F5fQ6S76LLPXkYhyLg7JL4_vrkRe@mail.gmail.com>
In-Reply-To: <AANLkTi=qrK2L+MA5F5fQ6S76LLPXkYhyLg7JL4_vrkRe@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 12247539188154659328
X-Ovh-Remote: 178.36.164.253 (178-36-164-253.adsl.inetia.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.03.2011 13:56, Anca Emanuel wrote:
> 2011/3/19 Piotr Hosowicz<piotr@hosowicz.com>:
>> Hello,
>>
>> I wrote lately, the problem persists, that's why I write again. I tested
>> git7 just now and it still does not work.
>
> Same problem here:
>
> [   12.923685] r8169 0000:04:00.0: eth0: link down
> [   12.923941] ADDRCONF(NETDEV_UP): eth0: link is not ready
>
> dmesg attached.

Nice to hear that I am not the only person with this problem. I forgot 
about the dmesg.

Regards,

Piotr Hosowicz

-- 
- Jasiu, jakie jest najszybsze zwierze na swiecie?
- Gepard, pszepani.
- A najszybszy ptak?
- Ptak geparda.
NP: Banda Do Sol - Fabito
NB: 2.6.38-git3
