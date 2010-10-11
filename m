Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753561Ab0JKIj3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 04:39:29 -0400
Received: from 68.mail-out.ovh.net ([91.121.185.69]:42579 "HELO
	68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753283Ab0JKIj2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 04:39:28 -0400
Message-ID: <4CB2CD3A.4020203@example.com>
Date: Mon, 11 Oct 2010 10:39:22 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100917 Icedove/3.0.8
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, maciej.rutecki@gmail.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: What is this? Should I worry?
References: <4CAFEFF1.8010202@example.com> <201010102039.31706.maciej.rutecki@gmail.com> <4CB20CED.8060403@example.com> <20101011061618.GA4899@liondog.tnic>
In-Reply-To: <20101011061618.GA4899@liondog.tnic>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 14788413802358665579
X-Ovh-Remote: 95.49.238.119 (afje119.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.10.2010 08:16, Borislav Petkov wrote:
> From: Piotr Hosowicz<piotr@hosowicz.com>
> Date: Sun, Oct 10, 2010 at 08:58:53PM +0200
>
>> On 10.10.2010 20:39, Maciej Rutecki wrote:
>>
>>> Can you check clean kernel (without any proprietary module)? That. 2.6.35
>>> works fine (it's a regression)?
>>
>> I build and boot every published kernel and this was the first time
>> I saw this error. I have NVidia graphics and use their driver.
>
> and this time, test the kernel without the nvidia module - use a free
> driver instead to rule out the possibility that the nvidia driver is the
> culprit.

The nouveau driver doesn't work for me. But I think that the NVidia 
driver is not the culprit. I use it always and didn't have such problems.

Regards,

Piotr Hosowicz

-- 
- Jasiu, jakie jest najszybsze zwierze na swiecie?
- Gepard, pszepani.
- A najszybszy ptak?
- Ptak geparda.
NP:  -
NB: 2.6.36-rc7-git2
