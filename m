Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753175Ab1CSOIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Mar 2011 10:08:20 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45658 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434Ab1CSOIR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Mar 2011 10:08:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=H32/HCtUBshitJiy3s/b95hmY7Oeh/LtAC2cg9VWM4XL7UBuOmauzm9y7SImL9v3Aa
         E3vpi6Df7f2TBZTC63P3e8N9KZYHGi3IU4/oD4Y59pXvZGe8tsHMyrvABH6Udl56oB11
         3ivkJS2ouLEo42kQp8KWn9SWeza+ygwn7lHdY=
MIME-Version: 1.0
In-Reply-To: <4D84A9F6.8080402@example.com>
References: <4D84A46B.1000407@example.com>
	<AANLkTi=qrK2L+MA5F5fQ6S76LLPXkYhyLg7JL4_vrkRe@mail.gmail.com>
	<4D84A9F6.8080402@example.com>
Date: Sat, 19 Mar 2011 16:08:16 +0200
Message-ID: <AANLkTimFGeHYEOxx=h883rRJL463g1CBUDS0wGM-52Nj@mail.gmail.com>
Subject: Re: No networking since git3
From: Anca Emanuel <anca.emanuel@gmail.com>
To: piotr@hosowicz.com
Cc: LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
        Francois Romieu <romieu@fr.zoreil.com>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/19 Piotr Hosowicz <piotr@hosowicz.com>:
> On 19.03.2011 13:56, Anca Emanuel wrote:
>>
>> 2011/3/19 Piotr Hosowicz<piotr@hosowicz.com>:
>>>
>>> Hello,
>>>
>>> I wrote lately, the problem persists, that's why I write again. I tested
>>> git7 just now and it still does not work.
>>
>> Same problem here:
>>
>> [   12.923685] r8169 0000:04:00.0: eth0: link down
>> [   12.923941] ADDRCONF(NETDEV_UP): eth0: link is not ready
>>
>> dmesg attached.
>
> Nice to hear that I am not the only person with this problem. I forgot about
> the dmesg.
>
> Regards,
>
> Piotr Hosowicz

Added CCs
