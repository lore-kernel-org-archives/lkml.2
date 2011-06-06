Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757274Ab1FFNUi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 09:20:38 -0400
Received: from mail.wdtv.com ([66.118.69.84]:39887 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755899Ab1FFNUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 09:20:36 -0400
From: Gene Heskett <gene.heskett@gmail.com>
To: Lars =?utf-8?q?T=C3=A4uber?= <taeuber@bbaw.de>
Subject: Re: [PROBLEM] reproduceable storage errors on high IO load
Date: Mon, 6 Jun 2011 09:20:32 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.38.8-pclos1.pae.bfs; KDE/4.6.3; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <20110606095127.21d23a70.taeuber@bbaw.de> <201106060559.03131.gene.heskett@gmail.com> <20110606130628.e86f0c67.taeuber@bbaw.de>
In-Reply-To: <20110606130628.e86f0c67.taeuber@bbaw.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201106060920.32257.gene.heskett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, June 06, 2011, Lars Täuber wrote:
>Hi Gene,
>
>thanks for your fast reply.
>
>Am Mon, 6 Jun 2011 05:59:02 -0400
>
>Gene Heskett <gene.heskett@gmail.com> schrieb:
>> On Monday, June 06, 2011, Lars Täuber wrote:
>[...]
>
>> >Is there something I do wrong? Could someone help me to debug this?
>> >Thanks
>> >Lars
>> 
>> Looking at your dmesg, I get the impression you have a bunch of disks
>> that are in need of a firmware update.  Unforch, the dmesg snippet
>> does not include the drive discovery and identification data.
>
>Attached is the whole dmesg from a fresh boot up. (I hope I'm allowed to
>send this to the ML!?)
>
>> However, I would back that data up to another medium before I did that
>> as I had the seagate firmware update scramble the blkid's and
>> partition names of one of two 1Tb drives I have.  Neither drive errors
>> now, but the read/write speeds for the 2nd identical drive are about
>> 1/3rd the rate of the first.
>
>There is no partition table nor any data on the disks, because I never
>could use the array.
>
>> Firmware updates are in the form of a bootable cd .iso, and you can
>> download the cd image from the makers site.
>
>I didn't find any firmware updates from WD. How do they manage to have
>all the drivers possibly needed to talk to the disks?
>
>Thanks again
>Lars
>
I started here:
<http://support.wdc.com/product/download.asp?modelno=WD2003FYYS&x=8&y=10>

I entered your drives model number, and got here:

<http://community.wdc.com/t5/News-Announcements/bd-p/Announcements>

That is the link I got when I entered the WDC drive # shown in your dmesg.
That looks like too many choices, and probably is, so I would email the 
support link shown and ask for clarification.  Be sure to use the full 
model number of the drive as shown on the drive or the packaging as its 
possible I blew it with my copy/paste here.

The point is, the stuff is there.  But its easier to find on Seagates site 
I believe.

Cheers, gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Receiving a million dollars tax free will make you feel better than
being flat broke and having a stomach ache.
		-- Dolph Sharp, "I'm O.K., You're Not So Hot"
