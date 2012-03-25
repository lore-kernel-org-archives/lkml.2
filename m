Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754890Ab2CYBTK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 21:19:10 -0400
Received: from mta103.odn.ne.jp ([143.90.14.143]:48071 "EHLO cmta103.odn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab2CYBTJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 21:19:09 -0400
Message-ID: <4F6E728A.3090203@yahoo.co.jp>
Date: Sun, 25 Mar 2012 10:19:06 +0900
From: "ANEZAKI, Akira" <fireblade1230@yahoo.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120316 Thunderbird/11.0
MIME-Version: 1.0
To: Gwendal Grignou <gwendal@google.com>
CC: IDE/ATA development list <linux-ide@vger.kernel.org>,
        Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Fwd: libata-pmp patch for 3.2.x and later for eSATA Port Multiplier
 Sil3726
References: <4F5ECD06.3000608@yahoo.co.jp> <4F5F7C4C.7080800@teksavvy.com> <4F662AFB.9050106@yahoo.co.jp> <CAMHSBOWg+rxxrVjf05r1tYDpW1S75XzdrLQ+U8TrjC9okRYtuA@mail.gmail.com> <4F6AAC37.7040907@yahoo.co.jp> <4F6B30D9.2070805@yahoo.co.jp> <CAMHSBOVD4wAtwAravVkDjyWV+Nwtuybt=yae=26PcGxxirw=Lg@mail.gmail.com> <4F6B679C.60004@yahoo.co.jp> <CAMHSBOWDYyLRREZNGqhBtvF_gSrvB-b=PVx3qULCqpc7yeJCcQ@mail.gmail.com> <4F6C1AE5.5060405@yahoo.co.jp> <CAMHSBOXuX1U8uPyN136AQ_LRW85Ex8EUu1-_hdBqnSMtdmg+0Q@mail.gmail.com> <4F6C4967.80309@yahoo.co.jp>
In-Reply-To: <4F6C4967.80309@yahoo.co.jp>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Gwendal,

I want to confirm one thing.
The kernel 3.1.x driver still works?

It seems to take long time to solve the problem. Of course I understand
staggered spin-up is better solution. But I can't wait it so long. And
it affects only SiI3726 only.

Best Regards,
Akira

(2012/03/23 18:59), ANEZAKI, Akira wrote:
> Hello Gwendal,
> 
> (2012/03/23 17:31), Gwendal Grignou wrote:
>>>>>> I notice however some messages I did not see before:
>>>>>>>> [    4.856382] ata7.15: Port Multiplier 1.1, 0x1095:0x3726 r23, 6 ports, feat 0x1/0x9
>>>>>>>> [    4.858742] ata7.00: hard resetting link
>>>>>>>> [   14.843039] ata7.00: softreset failed (timeout)
>>>>>>>> [   17.836402] ata7.15: qc timeout (cmd 0xe4)
>>>>>> The later indicates that the PMP is stuck and the host can not read
>>>>>> its internal register.
>>>>>> Is it possible that the PMP in these 4 enclosures you are using have a
>>>>>> different firmware than the other ones?
>>>>>> Firmware 1.0114 is available at:
>>>>>> http://www.siliconimage.com/support/searchresults.aspx?pid=26&cat=23
>>>>>>
>>>>>> From the release notes:
>>>>>> """- Fix SRST and initial two RegFIS Problem."""
>>>
>>> I'm still fixing broken RAID. Sorry for my slow response.
> 
> I checked those firmware version. All of them use version 1.0114.
> 
> Best Regards,
> Akira

