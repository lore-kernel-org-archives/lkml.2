Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab1GGNYf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:24:35 -0400
Received: from 17.mo1.mail-out.ovh.net ([87.98.179.142]:56642 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755650Ab1GGNYe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:24:34 -0400
X-Greylist: delayed 1202 seconds by postgrey-1.27 at vger.kernel.org; Thu, 07 Jul 2011 09:24:34 EDT
Message-ID: <4E15AF1C.7080103@example.com>
Date: Thu, 07 Jul 2011 15:05:32 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110303 Icedove/3.0.11
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Jonathan Cameron <jic23@cam.ac.uk>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: Re: Build issue with linux next. duplicate member _count in mm_types.h
References: <4E143120.2020501@cam.ac.uk> <alpine.DEB.2.00.1107060933460.17202@router.home>
In-Reply-To: <alpine.DEB.2.00.1107060933460.17202@router.home>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 12619930582756323629
X-Ovh-Remote: 178.36.17.0 (178-36-17-0.adsl.inetia.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -270
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.07.2011 16:46, Christoph Lameter wrote:
> On Wed, 6 Jul 2011, Jonathan Cameron wrote:
>
>> Getting:
>>
>>    CHK     include/linux/version.h
>>    CHK     include/generated/utsrelease.h
>> make[1]: `include/generated/mach-types.h' is up to date.
>>    CC      arch/arm/kernel/asm-offsets.s
>> In file included from include/linux/sched.h:64:0,
>>                   from arch/arm/kernel/asm-offsets.c:13:
>> include/linux/mm_types.h:74:15: error: duplicate member '_count'
>> make[1]: *** [arch/arm/kernel/asm-offsets.s] Error 1
>> make: *** [prepare0] Error 2

I have the same error on x86_64. I'll try again withj your patch.

Regards,

Piotr Hosowicz

-- 
Zatrzymuje siê samochód na sejmowym parkingu. Podchodzi do niego 
ochroniarz i mówi:
- Pan tu parkuje?! Tu Sejm ... Ministrowie, politycy, pos³owiei ...
- Dziêki, w³±czê alarm.
NP: Nemo -
NB: 3.0.0-rc6
