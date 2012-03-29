Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753858Ab2C2G2G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 02:28:06 -0400
Received: from mta103.odn.ne.jp ([143.90.14.143]:56011 "EHLO cmta103.odn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751323Ab2C2G16 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 02:27:58 -0400
Message-ID: <4F7400EC.8060301@yahoo.co.jp>
Date: Thu, 29 Mar 2012 15:27:56 +0900
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
References: <4F5ECD06.3000608@yahoo.co.jp> <4F5F7C4C.7080800@teksavvy.com> <4F662AFB.9050106@yahoo.co.jp> <CAMHSBOWg+rxxrVjf05r1tYDpW1S75XzdrLQ+U8TrjC9okRYtuA@mail.gmail.com> <4F6AAC37.7040907@yahoo.co.jp> <4F6B30D9.2070805@yahoo.co.jp> <CAMHSBOVD4wAtwAravVkDjyWV+Nwtuybt=yae=26PcGxxirw=Lg@mail.gmail.com> <4F6B679C.60004@yahoo.co.jp> <CAMHSBOWDYyLRREZNGqhBtvF_gSrvB-b=PVx3qULCqpc7yeJCcQ@mail.gmail.com> <4F6C1AE5.5060405@yahoo.co.jp> <CAMHSBOXuX1U8uPyN136AQ_LRW85Ex8EUu1-_hdBqnSMtdmg+0Q@mail.gmail.com> <4F6C4967.80309@yahoo.co.jp> <4F6E728A.3090203@yahoo.co.jp> <CAMHSBOVtj8pXVtSK7qUmzSzXTCJWTK6-m7ZY6TB3gj-dT70ptw@mail.gmail.com> <4F6FBB3E.8060409@yahoo.co.jp> <4F6FD4CD.5040608@yahoo.co.jp> <4F703BEB.1040309@yahoo.co.jp> <4F70527A.4000005@world.odn.ne.jp> <CAMHSBOWOLj0igQYK16qQ+BznzmS2KV89dw4ahRz0h5tUw+YOdQ@mail.gmail.com> <4F72A1C5.8070704@yahoo.co.jp> <CAMHSBOVaswiCg4WisCLMWkqndixM54wzN6Gwn1bTaKKLsCk1Yg@mail.gmail.com>
In-Reply-To: <CAMHSBOVaswiCg4WisCLMWkqndixM54wzN6Gwn1bTaKKLsCk1Yg@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Gwendal,

Thank you for your great help. I'll ask to Fedora Project about this.

Best Regrads,
Akira

(2012/03/29 15:08), Gwendal Grignou wrote:
> On Wed, Mar 28, 2012 at 1:29 PM, ANEZAKI, Akira
> <fireblade1230@yahoo.co.jp> wrote:
>> Hello Gwendal,
>>
>> (2012/03/27 20:17), Gwendal Grignou wrote:
>>> Regarding the machine with 10 disks, I see that all the drives have
>>> been found; I don't see any other error from the /var/log/messages
>>> snippet that could explain md not finding the volumes.
>>
>> I have attached 11 disks log. RAID1 is not assembled. Both of md1 and
>> md2 were not assembled. md1 is root partition.
> From your original post md1 is composed of sda2 and sdb2. Both disks
> are not behind a PMP, so it is different problem.
> 
> Gwendal.
>>
>> Best Regards,
>> Akira
>>
  :

