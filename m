Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab0EUVbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 17:31:33 -0400
Received: from 64.mail-out.ovh.net ([91.121.185.65]:43119 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752352Ab0EUVbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 17:31:32 -0400
Message-ID: <4BF6FBB0.6060407@example.com>
Date: Fri, 21 May 2010 23:31:28 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: piotr@hosowicz.com
CC: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org
Subject: Re: What's up with wireless drivers?
References: <4BF6F2E4.5030800@example.com> <20100521210729.GC2495@tuxdriver.com> <4BF6F959.5040401@example.com>
In-Reply-To: <4BF6F959.5040401@example.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 18136558650178236786
X-Ovh-Remote: 83.24.109.69 (dob69.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21.05.2010 23:21, Piotr Hosowicz wrote:
> On 21.05.2010 23:07, John W. Linville wrote:
>> On Fri, May 21, 2010 at 10:53:56PM +0200, Piotr Hosowicz wrote:
>>> Hello,
>>>
>>> I try to build kernel from git source. Now n-th build try is
>>> performing, each time it failed on wireless drivers - Atheros,
>>> Marvel etc. Did I miss something?
>>>
>>> Regards,
>>>
>>> Piotr Hosowicz
>>
>> Perhaps you should post your actual output from the build failure?
>
> I dont have it right now, I disabled wireless at all and started build.
> The output to the console was make-kpkg ordinary message - saying that
> sub build finished with error code 2 AFAIR, it stopped each time on
> wireless drivers.

Zonk! It seems that the problem is not only with wireless, now it broke 
here:

(snip)
   CC [M]  drivers/net/usb/int51x1.o
   CC [M]  drivers/net/usb/cdc-phonet.o
   CC [M]  drivers/net/wan/lmc/lmc_media.o
   CC [M]  drivers/net/wan/lmc/lmc_main.o
   CC [M]  drivers/net/wan/wanxl.o
   CC [M]  drivers/net/usb/ipheth.o
   LD [M]  drivers/net/wan/cyclomx.o
   CC [M]  drivers/net/usb/sierra_net.o
   CC [M]  drivers/net/wan/lmc/lmc_proto.o
   LD [M]  drivers/net/wan/lmc/lmc.o
make[1]: Opuszczenie katalogu `/usr/src/linus/linux-2.6-20100521-2044'
make: *** [debian/stamp/build/kernel] B³±d 2

Opuszczenie katalogu `/usr/src/linus/linux-2.6-20100521-2044' is 
"leaving directory", B³±d is error.

I give up for now, I must go to sleep.

Regards and good night.

Piotr Hosowicz


-- 
TV: "W tej chwili, ¿e siê tak wyra¿ê, zaliczonych mamy 17 zawodniczek."
NP: Rage Against The Machine - Know Your Enemy
NB: 2.6.34-20100521-1728
