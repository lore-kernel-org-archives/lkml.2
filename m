Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0EWNyd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 09:54:33 -0400
Received: from 63.mail-out.ovh.net ([91.121.185.56]:50773 "HELO
	63.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754362Ab0EWNyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 09:54:32 -0400
Message-ID: <4BF93392.7010803@example.com>
Date: Sun, 23 May 2010 15:54:26 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: Randy Dunlap <rdunlap@xenotime.net>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: What's up with wireless drivers?
References: <4BF6F2E4.5030800@example.com>	<20100521210729.GC2495@tuxdriver.com>	<4BF6F959.5040401@example.com>	<4BF6FBB0.6060407@example.com> <20100521151203.f94c1d3e.rdunlap@xenotime.net> <4BF7073A.4090506@example.com> <4BF7986C.4030505@example.com> <4BF7D185.2040705@example.com> <4BF7D86B.3020204@example.com> <4BF7DDAA.1080307@gmail.com> <4BF7DEE7.9010801@example.com> <4BF7DFDA.3000604@gmail.com> <4BF7E470.6080409@example.com> <4BF7E769.1090102@gmail.com>
In-Reply-To: <4BF7E769.1090102@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 3716595594526093640
X-Ovh-Remote: 83.24.90.195 (dni195.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.05.2010 16:17, Justin P. Mattock wrote:
> On 05/22/2010 07:04 AM, Piotr Hosowicz wrote:
>> On 22.05.2010 15:44, Justin P. Mattock wrote:
>>
>>> what about strace make
>>> (maybe will give you info)
>>
>> May be I'll try like that if the problem persists. I will produce tons
>> of output I believe :-(
>>
>
>
> yeah it does,
> you can always send the
> output to a file i.g.
> strace -o filename make
> anything at this point though
> to see what is crapping out

I did not try it yet, but I update the source through git and tested:

make M=drivers/net/wireless modules

And they had built flawlessly. But main build with make-kpkg 
kernel_image nevertheless still fails. I don;t know what to do. I don't 
want to do those strace's, because it will take awfully long.

Regards,

Piotr Hosowicz

-- 
Z cyklu "Uroki demokracji", czyli pytania i odpowiedzi w teledurniejach:
- Ile metrów ma kilometr?
- Trzy.
NP: Slash - Ghost (Feat. Ian Astbury)
NB: 2.6.34-20100521-1728
