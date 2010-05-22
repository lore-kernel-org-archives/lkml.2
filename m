Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754973Ab0EVNNY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 May 2010 09:13:24 -0400
Received: from 31.mail-out.ovh.net ([213.186.62.10]:44188 "HELO
	31.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753002Ab0EVNNV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 May 2010 09:13:21 -0400
Message-ID: <4BF7D86B.3020204@example.com>
Date: Sat, 22 May 2010 15:13:15 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: Randy Dunlap <rdunlap@xenotime.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: What's up with wireless drivers?
References: <4BF6F2E4.5030800@example.com>	<20100521210729.GC2495@tuxdriver.com>	<4BF6F959.5040401@example.com>	<4BF6FBB0.6060407@example.com> <20100521151203.f94c1d3e.rdunlap@xenotime.net> <4BF7073A.4090506@example.com> <4BF7986C.4030505@example.com> <4BF7D185.2040705@example.com>
In-Reply-To: <4BF7D185.2040705@example.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 15594839611594142066
X-Ovh-Remote: 95.49.242.247 (afji247.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.05.2010 14:43, Piotr Hosowicz wrote:
> On 22.05.2010 10:40, Piotr Hosowicz wrote:
>> On 22.05.2010 00:20, Piotr Hosowicz wrote:
>>> On 22.05.2010 00:12, Randy Dunlap wrote:
>>>> On Fri, 21 May 2010 23:31:28 +0200 Piotr Hosowicz wrote:
>>>>
>>>>> On 21.05.2010 23:21, Piotr Hosowicz wrote:
>>>>>> On 21.05.2010 23:07, John W. Linville wrote:
>>>>>>> On Fri, May 21, 2010 at 10:53:56PM +0200, Piotr Hosowicz wrote:
>>>>>>>> Hello,
>>>>>>>>
>>>>>>>> I try to build kernel from git source. Now n-th build try is
>>>>>>>> performing, each time it failed on wireless drivers - Atheros,
>>>>>>>> Marvel etc. Did I miss something?
>>>>>>>>
>>>>>>>> Regards,
>>>>>>>>
>>>>>>>> Piotr Hosowicz
>>>>>>>
>>>>>>> Perhaps you should post your actual output from the build failure?
>>>>>>
>>>>>> I dont have it right now, I disabled wireless at all and started
>>>>>> build.
>>>>>> The output to the console was make-kpkg ordinary message - saying
>>>>>> that
>>>>>> sub build finished with error code 2 AFAIR, it stopped each time on
>>>>>> wireless drivers.
>>>>>
>>>>> Zonk! It seems that the problem is not only with wireless, now it
>>>>> broke
>>>>> here:
>>>>>
>>>>> (snip)
>>>>> CC [M] drivers/net/usb/int51x1.o
>>>>> CC [M] drivers/net/usb/cdc-phonet.o
>>>>> CC [M] drivers/net/wan/lmc/lmc_media.o
>>>>> CC [M] drivers/net/wan/lmc/lmc_main.o
>>>>> CC [M] drivers/net/wan/wanxl.o
>>>>> CC [M] drivers/net/usb/ipheth.o
>>>>> LD [M] drivers/net/wan/cyclomx.o
>>>>> CC [M] drivers/net/usb/sierra_net.o
>>>>> CC [M] drivers/net/wan/lmc/lmc_proto.o
>>>>> LD [M] drivers/net/wan/lmc/lmc.o
>>>>> make[1]: Opuszczenie katalogu `/usr/src/linus/linux-2.6-20100521-2044'
>>>>> make: *** [debian/stamp/build/kernel] B³±d 2
>>>>>
>>>>> Opuszczenie katalogu `/usr/src/linus/linux-2.6-20100521-2044' is
>>>>> "leaving directory", B³±d is error.
>>>>
>>>> That still doesn't show the actual error/problem message...
>>>
>>> Because there was no other messages, maybe Debian make-kpkg mutes them
>>> some way. I can try tommorrow the classic linux way and test it. I
>>> attach botching config.
>>
>> I git-pulled and have run build with make-kpkg --verbose, again failed.
>> This is the tail of the output:
>>
>
> (snip)
>
> I tried git8 from kernel.org and the make-kpkg build fails on iwlwifi.
> I'll give up for today I think.

I gave it one more try and it failed again like in my first post yesterday:

   CC [M]  drivers/net/wireless/rtl818x/rtl8187_rtl8225.o
   CC [M]  drivers/net/wireless/zd1211rw/zd_usb.o
   CC [M]  drivers/net/wireless/rtl818x/rtl8187_leds.o
   CC [M]  drivers/net/wireless/rtl818x/rtl8187_rfkill.o
   LD [M]  drivers/net/wireless/rtl818x/rtl8180.o
   LD [M]  drivers/net/wireless/rtl818x/rtl8187.o
   LD [M]  drivers/net/wireless/ath/ath9k/ath9k_hw.o
   LD [M]  drivers/net/wireless/ath/ath9k/ath9k_common.o
   LD [M]  drivers/net/wireless/ath/ath9k/ath9k_htc.o
   LD [M]  drivers/net/wireless/ath/ath.o
   LD [M]  drivers/net/wireless/zd1211rw/zd1211rw.o
make[1]: Opuszczenie katalogu `/usr/src/linux-2.6.34-git8'
make: *** [debian/stamp/build/kernel] B³±d 2

zd1211rw is in wireless Zydas device driver, behaves like yesterday

I am giving up for a time being or may be someone will help me here.

Regards,

Piotr Hosowicz

-- 
W trosce o najm³odsze pokolenie, nasi ustawodawcy winni znowelizowaæ
ustawê o wychowaniu w trze¼wo¶ci i przeciwdzia³aniu alkoholizmowi tak,
¿eby zakazaæ wprowadzania na rynek gier planszowych, których celem
jest jak najszybsze dotarcie do mety.
NP: Chickenfoot - Sexy Little Thing
NB: 2.6.34-20100521-1728
