Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752889Ab0HPH7p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 03:59:45 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:58427 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752750Ab0HPH7o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 03:59:44 -0400
Message-ID: <4C68EFE8.20202@example.com>
Date: Mon, 16 Aug 2010 09:59:36 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100805 Icedove/3.0.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Sam Ravnborg <sam@ravnborg.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ioctl definition - has it changed recently?
References: <4C67023D.6050603@example.com> <201008160858.42947.arnd@arndb.de> <4C68E4A5.3050800@example.com> <201008160917.23260.arnd@arndb.de>
In-Reply-To: <201008160917.23260.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 17287911595264340228
X-Ovh-Remote: 83.24.80.89 (dmy89.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16.08.2010 09:17, Arnd Bergmann wrote:
> On Monday 16 August 2010 09:11:33 Piotr Hosowicz wrote:
>>> and then make it use the unlocked_ioctl operation.
>>
>> This I do not know. Can You help me?
>>
>
> Just take a look at all the other patches that went into the
> kernel to do this for other drivers. You only really
> need to change the line with .ioctl=... to .unlocked_ioctl=
> and change the prototype of the referenced function to
>
> static long foo_ioctl(struct file *file, unsigned int cmd, unsigned long arg)

int           nv_kern_ioctl(struct inode *, struct file *, unsigned int, 
unsigned long);

It seems different. How to change it? Now it works, I built it without 
your remarks, exactly how I described on my blog:

http://phosowicz.jogger.pl/2010/08/15/nvidia-graphics-in-fresh-kernels/

Regards,

Piotr Hosowicz

-- 
Polsat: ogl±dasz z rodzink± reklamy, a tu nagle - trach! - film!
NP: Patrick O'Hearn - Chance
NB: 2.6.36-rc1
