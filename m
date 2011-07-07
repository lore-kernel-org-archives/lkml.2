Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751434Ab1GGEnt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 00:43:49 -0400
Received: from mail.wdtv.com ([66.118.69.84]:52602 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756Ab1GGEns (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 00:43:48 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: Knut Petersen <Knut_Petersen@t-online.de>,
        Knut Petersen <Knut_Petersen@t-online.de>
Subject: Re: [BUG 2.6.38.8] Bisected to commit 5fb46ae7b8c51b05a12c6a66108e8d398c20ee09
Date: Thu, 7 Jul 2011 00:43:45 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.38.8-pclos1.pae.bfs; KDE/4.6.4; i686; ; )
Cc: Greg KH <gregkh@suse.de>, axboe@kernel.dk, kay.sievers@vrfy.org,
        "David S. Miller" <davem@davemloft.net>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <4E11BAE0.5020208@t-online.de> <20110707003338.GA25302@suse.de> <4E1534DC.3020306@t-online.de>
In-Reply-To: <4E1534DC.3020306@t-online.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107070043.45510.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 07, 2011, Knut Petersen wrote:
>Am 07.07.2011 02:33, schrieb Greg KH:
>> On Mon, Jul 04, 2011 at 03:06:40PM +0200, Knut Petersen wrote:
>>> Hi everybody!
>>> 
>>> An openSuse 11.2 system reliably refused to boot properly with kernel
>>> 2.6.38.8 although the prior 2.6.38.y kernels worked fine.  After a
>>> few seconds booting stopped. Several <ctrl-c> did help, but a lot of
>>> services were not started properly, only the root partition was
>>> available. Nothing unusual could be found in the kernel messages.
>>> 
>>> I bisected the problem to commit
>>> 5fb46ae7b8c51b05a12c6a66108e8d398c20ee09.
>>> 
>>> That gave me the idea to disconnect the Plextor PX-755A dvd drive  and
>>> to try 2.6.38.8 again. It booted without problem.
>> 
>> Does the 2.6.39.2 kernel work properly for you?
>
>Yes.  Kernel 2.6.38[,1,2,3,4,5,6,7] 2.6.39[1,2] 3.0-git are ok, only
>2.6.38.8 is broken in the way described above.
>
>cu,
> knut

FWIW guys, running a Texstar built 2.6.38.8-pae-bfs kernel here, but my dvd 
writer, which works, is (from messages at last boot)
scsi 4:0:0:0: CD-ROM ATAPI iHAS324 A BL1D PQ: 0 ANSI: 5

Assigned to /dev/sr0.

And I cannot duplicate this.  My problems are shutdown/reboot related, it 
"turning off swap"
"-f" on the next line, and it is hung till I tap the hardware reset button.

In your case I'd suspect something in the Plextor that could be as simple 
as a dusty led/ir combo that detects the disk.  But dvd writers have become 
so cheap they are hardly worth pulling the covers off to check.

Cheers, gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
O give me a home,
Where the buffalo roam,
Where the deer and the antelope play,
Where seldom is heard
A discouraging word,
'Cause what can an antelope say?
