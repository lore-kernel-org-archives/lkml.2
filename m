Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab1CUDu2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Mar 2011 23:50:28 -0400
Received: from 30.mail-out.ovh.net ([213.186.62.213]:56239 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752659Ab1CUDu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Mar 2011 23:50:26 -0400
Message-ID: <4D86CAFE.5050408@example.com>
Date: Mon, 21 Mar 2011 04:50:22 +0100
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
MIME-Version: 1.0
To: hayeswang <hayeswang@realtek.com>
CC: "'Francois Romieu'" <romieu@fr.zoreil.com>,
        "'Mike Galbraith'" <efault@gmx.de>,
        "'LKML'" <linux-kernel@vger.kernel.org>, benh@debian.org
Subject: Re: Where to get the network NIC's firmware? rtl_nic/rtl8105e-1.fw
References: <201103101209.p2AC9YdZ014233@violet.fr.zoreil.com> <20110316202220.GA14741@electric-eye.fr.zoreil.com> <4D8244F4.3020500@example.com> <7F300D72A54145B2BC4AF2E1CBE0CA10@realtek.com.tw>
In-Reply-To: <7F300D72A54145B2BC4AF2E1CBE0CA10@realtek.com.tw>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 14627410115926847965
X-Ovh-Remote: 178.36.63.3 (178-36-63-3.adsl.inetia.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.03.2011 03:47, hayeswang wrote:
>
>
>> -----Original Message-----
>> From: Piotr Hosowicz [mailto:piotr@hosowicz.com]
>> Sent: Friday, March 18, 2011 1:29 AM
>> To: Francois Romieu
>> Cc: Mike Galbraith; LKML; Hayeswang; benh@debian.org
>> Subject: Re: Where to get the network NIC's firmware?
>> rtl_nic/rtl8105e-1.fw
>>
>> On 16.03.2011 21:22, Francois Romieu wrote:
>>> You can get it there:
>>>
>>>
>> http://git.kernel.org/pub/scm/linux/kernel/git/romieu/linux-firmware.g
>>> it
>>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/romieu/linux-firmware.gi
>>> t
>>>
>>> It has already been submitted to the maintainer of linux-firmware.
>>
>> Hello,
>>
>> The problem persists, I have on disk:
>>
>> # ls /lib/firmware/rtl_nic/
>> rtl8105e-1.fw  rtl8168d-1.fw  rtl8168d-2.fw  rtl8168e-1.fw
>> rtl8168e-2.fw
>>
>
> Excuse me. I don't understand what your question is. Do you mean you cannot
> build the kernel without the firmware? Or, you just don't know where to download
> the firmware? Or, your NIC work abnormally after loading the firmware?
>
>> From your information, I see the firmware in the correct path
> "/lib/firmeare/rtl_nic/", so it seems fine.

Nevermind, the problem was in the kernel (bug), not firmware. Sorry for 
the noise.

Regards,

Piotr Hosowicz

-- 
Z cyklu "Uroki demokracji", czyli pytania i odpowiedzi w teledurniejach:
- Który aktor amerykañski jest mê¿em Nicole Kidman?
- Forrest Gump.
NP:  -
NB: 2.6.38-20110319-1638-net++
