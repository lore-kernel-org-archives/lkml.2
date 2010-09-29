Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756388Ab0I2NoD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Sep 2010 09:44:03 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:44947 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1756337Ab0I2NoA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Sep 2010 09:44:00 -0400
X-Authenticated: #31060655
X-Provags-ID: V01U2FsdGVkX18CE55cSgYCw8hB1u5rrtK5X5kKZDWBCs7cnqBoWt
	I86CKqZH53s498
Message-ID: <4CA3429E.4070104@gmx.net>
Date: Wed, 29 Sep 2010 15:43:58 +0200
From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.23) Gecko/20090410 SUSE/1.1.18-0.1 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Ben Hutchings <bhutchings@solarflare.com>
CC: netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        sf-linux-drivers <linux-net-drivers@solarflare.com>,
        flashrom <flashrom@flashrom.org>
Subject: Re: [RFC] Online firmware upgrade in non-embedded systems
References: <1285696787.2282.45.camel@achroite.uk.solarflarecom.com>	 <4CA26F35.6060408@gmx.net>	 <1285763700.2283.6.camel@achroite.uk.solarflarecom.com>	 <4CA334FA.2080707@gmx.net> <1285765850.2283.15.camel@achroite.uk.solarflarecom.com>
In-Reply-To: <1285765850.2283.15.camel@achroite.uk.solarflarecom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.09.2010 15:10, Ben Hutchings wrote:
> On Wed, 2010-09-29 at 14:45 +0200, Carl-Daniel Hailfinger wrote:
>   
>> On 29.09.2010 14:35, Ben Hutchings wrote:
>>     
>>> On Wed, 2010-09-29 at 00:41 +0200, Carl-Daniel Hailfinger wrote:
>>>   
>>>       
>>>> [adding flashrom@flashrom.org to CC, senders will be whitelisted after a
>>>> short delay]
>>>>
>>>> On 28.09.2010 19:59, Ben Hutchings wrote:
>>>>     
>>>>         
>>>>> Network and disk controllers normally have at least some firmware in
>>>>> flash to support their use as boot devices. [...]
>>>>>   
>>>>>       
>>>>>           
>>>> Given that the flashrom utility <http://www.flashrom.org/> (GPLv2)
>>>> supports flashing many network cards, SATA/PATA controllers, graphics
>>>> cards, and of course the main system firmware/BIOS/EFI, and it does that
>>>> from userspace without any kernel support,
>>>>     
>>>>         
>>> [...]
>>>
>>> I'm looking for a clean solution, not a hack.
>>>   
>>>       
>> What would qualify as a clean solution?
>>     
>
> One where hardware access is mediated by the kernel, and doesn't involve
> unloading or potentially conflicting with the driver for that hardware.
>   

flashrom can ask the kernel driver to "please stop accessing flash". No
unloading needed, no conflict in place.


>> And is cross-platform code one of your goals?
>>     
>
> Not at this level.  At the application level, yes, but we already have a
> working application so I'm not interested in using flashrom for that.
>   

I see. Just because I'm interested in how other flashing applications
solve this: Does that application work on *BSD as well? And could you
tell me the name of the app so I can take a look at it? Thanks.

Regards,
Carl-Daniel

-- 
http://www.hailfinger.org/

