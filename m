Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0HQNLZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 09:11:25 -0400
Received: from 68.mail-out.ovh.net ([91.121.185.69]:60002 "HELO
	68.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751985Ab0HQNLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 09:11:24 -0400
Message-ID: <4C6A8A73.1070003@example.com>
Date: Tue, 17 Aug 2010 15:11:15 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioctl definition - has it changed recently?
References: <4C67023D.6050603@example.com> <201008160858.42947.arnd@arndb.de> <4C68E4A5.3050800@example.com> <201008160917.23260.arnd@arndb.de> <4C68EFE8.20202@example.com>
In-Reply-To: <4C68EFE8.20202@example.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 9976880551610052978
X-Ovh-Remote: 83.24.75.141 (dmt141.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.08.2010 09:59, Piotr Hosowicz wrote:
> On 16.08.2010 09:17, Arnd Bergmann wrote:
>> On Monday 16 August 2010 09:11:33 Piotr Hosowicz wrote:
>>>> and then make it use the unlocked_ioctl operation.
>>>
>>> This I do not know. Can You help me?
>>>
>>
>> Just take a look at all the other patches that went into the
>> kernel to do this for other drivers.

I do not know how to find them. :-(

 > You only really
>> need to change the line with .ioctl=... to .unlocked_ioctl=

Ok, this is simple.

>> and change the prototype of the referenced function to
>>
>> static long foo_ioctl(struct file *file, unsigned int cmd, unsigned
>> long arg)
>
> int nv_kern_ioctl(struct inode *, struct file *, unsigned int, unsigned
> long);
>
> It seems different. How to change it? Now it works, I built it without
> your remarks, exactly how I described on my blog:
>
> http://phosowicz.jogger.pl/2010/08/15/nvidia-graphics-in-fresh-kernels/

Ok, as I wrote the prototypes differ. What should I do with the inode 
parameter?

Regards,

Piotr Hosowicz

-- 
- Za moich czasów to w sklepach by³ tylko ocet i denaturat!
- Tato, przestañ, ¿e w ca³ym Tesco by³ tylko ocet i denaturat!
NP:  -
NB: 2.6.36-rc1
