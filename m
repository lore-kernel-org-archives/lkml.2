Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377Ab0ENBwM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 21:52:12 -0400
Received: from 29.mail-out.ovh.net ([87.98.216.213]:38076 "HELO
	29.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755122Ab0ENBwJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 21:52:09 -0400
Message-ID: <4BECACC3.3020309@example.com>
Date: Fri, 14 May 2010 03:52:03 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100411 Icedove/3.0.4
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Re: General questiin about SYSFS
References: <4BEC4B0D.8010102@example.com> <4BEC4CD6.6090402@example.com> <4BEC52C0.1000403@xenotime.net>
In-Reply-To: <4BEC52C0.1000403@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 12449356745807720949
X-Ovh-Remote: 83.24.77.38 (dmv38.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.05.2010 21:28, Randy Dunlap wrote:
> Piotr Hosowicz wrote:
>> On 13.05.2010 20:55, Piotr Hosowicz wrote:
>>
>>> I could find the option in menuconfig and I don't want to edit .config
>>> by hand, because there are various *SYSFS* options there.
>>
>> Sorry, I mistyped, I meant I _cannot_ find it in menuconfig nor in .config.
>
> The only thing about  SYSFS that is deprecated AFAIK is in init/Kconfig:
>
> config SYSFS_DEPRECATED_V2
> 	bool "enable deprecated sysfs features to support old userspace tools"
> 	depends on SYSFS
> 	default n
> 	select SYSFS_DEPRECATED
> 	help
> 	  This option switches the layout of sysfs to the deprecated
> 	  version. Do not use it on recent distributions.

Thanks, I have it disabled. I asked tyhe question because of such 
messages during boot:

May 13 16:26:24 aapi205 udevd[1432]: SYSFS{}= will be removed in a 
future udev version, please use ATTR{}= to match the event device, or 
ATTRS{}= to match a parent device, in 
/etc/udev/rules.d/025_logitechmouse.rules:21

As far as I can see this is rather udev question. I don't know what to 
do about those messages. Can you give me a hint?

For now I upgraded udev to 154-1, I will see in the morning after I 
build new kernel if this helps.

Regards,

Piotr Hosowicz

-- 
TV: "Rosjanki osi±gnê³y szczyt w niew³a¶ciwym miejscu, w
niew³a¶ciwym czasie i w³a¶ciwie zupe³nie niepotrzebnie."
NP: Patrick O'Hearn - Facing the Sun
NB: 2.6.34-rc7-git4
