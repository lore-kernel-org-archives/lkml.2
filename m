Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab0EXCyK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 22:54:10 -0400
Received: from 27.mail-out.ovh.net ([91.121.30.210]:38897 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755915Ab0EXCyJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 22:54:09 -0400
Message-ID: <4BF9EA49.8050007@example.com>
Date: Mon, 24 May 2010 04:54:01 +0200
From: Piotr Hosowicz <piotr@hosowicz.com>
Reply-To: piotr@hosowicz.com
Organization: hosowicz.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100515 Icedove/3.0.4
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Jiri Slaby <jirislaby@gmail.com>,
       "Justin P. Mattock" <justinmattock@gmail.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       linux-kernel@vger.kernel.org
Subject: Re: What's up with wireless drivers?
References: <4BF6F2E4.5030800@example.com>	<20100521210729.GC2495@tuxdriver.com>	<4BF6F959.5040401@example.com>	<4BF6FBB0.6060407@example.com>	<20100521151203.f94c1d3e.rdunlap@xenotime.net>	<4BF7073A.4090506@example.com>	<4BF7986C.4030505@example.com>	<4BF7D185.2040705@example.com>	<4BF7D86B.3020204@example.com>	<4BF7DDAA.1080307@gmail.com>	<4BF7DEE7.9010801@example.com>	<4BF7DFDA.3000604@gmail.com>	<4BF7E470.6080409@example.com>	<4BF7E769.1090102@gmail.com>	<4BF93392.7010803@example.com>	<4BF96B00.5060905@gmail.com>	<4BF973E5.6050802@example.com> <20100523145319.89008e2e.rdunlap@xenotime.net>
In-Reply-To: <20100523145319.89008e2e.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Ovh-Tracer-Id: 16883150578570850805
X-Ovh-Remote: 83.6.189.33 (abaz33.neoplus.adsl.tpnet.pl)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-Spam-Check: DONE|U 0.5/N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23.05.2010 23:53, Randy Dunlap wrote:
> On Sun, 23 May 2010 20:28:53 +0200 Piotr Hosowicz wrote:
>
>> On 23.05.2010 19:50, Jiri Slaby wrote:
>>> On 05/23/2010 03:54 PM, Piotr Hosowicz wrote:
>>>> And they had built flawlessly. But main build with make-kpkg
>>>> kernel_image nevertheless still fails. I don;t know what to do. I don't
>>>> want to do those strace's, because it will take awfully long.
>>>
>>> Why don't you just look at the actual error which is likely somewhere
>>> above because of parallel build? And when you are posting outputs, first
>>> switch your locale to en so that we can parse the output.
>>
>> I tried again and the error is about CEPH. I attach the typescript. I am
>> totaly confused, now build breakse in yet another place than before.
>>
>> Regards,
>>
>> Piotr Hosowicz
>>
>> PS: I ordered make modules without calling make first, I on't know if
>> it's ok.
>
>
>    CC [M]  fs/ceph/msgpool.o
> fs/ceph/msgpool.c: In function ___ceph_msgpool_put___:
> fs/ceph/msgpool.c:173: error: implicit declaration of function ___kref_set___
> make[2]: *** [fs/ceph/msgpool.o] B____d 1
> make[1]: *** [fs/ceph] B____d 2
> make: *** [fs] B____d 2
>
>
> Known problem, but I haven't seen a fix for it yet.
>
> And note how it says Error 1, not just Error 2.
> Error 1 is the primary error.  Just showing us Error 2 is mostly useless.

Thanks, the kernel is built and booted as you can see, but there is an 
error after boot, I'll start a separate thread about it.

Regards,

Piotr Hosowicz

-- 
"Bardzo fajna firma, tylko czasami nie p³aci. Do jej g³ównych
zalet nale¿±: ekspres ci¶nieniowy (ale tylko na jednym z piê-
ter) oraz fajne widoki z salki konferencyjnej. No i jakie¶
pó³ roku temu odesz³o 90% pracowników dzia³u IT, ale mo¿e nie
mieli racji ;)"
NP: Slash - Ghost (Feat. Ian Astbury)
NB: 2.6.34-20100524-0407
