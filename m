Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab0GCTV6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 15:21:58 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:59621 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755838Ab0GCTV4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 15:21:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PT3Dsm+sC37Zk1d+6lTQRUUCYAts+o8Ak6xVHZp99YvyHGVR5QgQAgohGdXOkwJ47a
         DbrOYbYhm7o3qKOo9npENsPibOzHN88oQDt4cmOV1hbLJ7j62WatwpaNN6FWa7VpTb9+
         Hk//re4DAJTPcdgLd3ZNlQYL0sPnLBulJVHgg=
MIME-Version: 1.0
In-Reply-To: <4C2F87C1.8000701@hardwarefreak.com>
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>
	<4C2F5ECB.1040505@kernel.org>
	<AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>
	<4C2F87C1.8000701@hardwarefreak.com>
Date: Sat, 3 Jul 2010 12:21:55 -0700
Message-ID: <AANLkTimVJEO-yF3GZ2ghX6DNPuAu-A-MNNO9x8Q1EpRc@mail.gmail.com>
Subject: Re: Drives missing at boot
From: Mark Knecht <markknecht@gmail.com>
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Tejun Heo <tj@kernel.org>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 3, 2010 at 11:56 AM, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> Mark Knecht put forth on 7/3/2010 11:06 AM:
>
>>>>    I have a newish machine - maybe 3 months old - which unreliably
>>>> finds its disk drives at each boot. Probably 40% of the time booting 1
>>>> or more drives will be missing.
>
> Please provide the make/model of the PC.  If it's whitebox or DIY please
> provide make/model of PSU, mobo and CPU.  How many USB peripherals are powered
> by the PC?  Are you powering a water cooling loop pump from the PC's power
> supply?  Is this PC in a temperature controlled environment (A/C)?
>
> --
> Stan
>

Build it myself.

Asus Rampage II Extreme motherboard
12GB Crucial DRAM currently installed (Holds 24GB)
Intel Core i7-980X CPU @ 3.33Ghz
Palit nVidia 9500GT-based graphics card
Sony Nec Optiarc AD-7241S-0B 24X Dual Layer DVD+/-RW SATA Drive
(5x) WD5002ABYS RE3 Enterprise Class 500GB hard drives

No external devices other than monitor, mouse, keyboard and the USB
interface to the UPS are attached. No USB, 1394 or eSATA are attached
at this time.

It's all powered by:

Corsair CMPSU-750TX 750-Watt TX Series 80 Plus Certified Power Supply

Air cooled using the stock Intel fan that came with the processor and
sitting in a home office environment.

The machine draws (steady state) about 250-275W according to both the
UPS it's hooked to as well as my trusty Kill-a-Watt. What it might
draw transient at power on while drives are spinning up I wouldn't
hazard a guess but it does seem to be well below the rating of the
supply. The PSU actually has something like 8 or 10 SATA power
connections, not that that means anything. I'm using 6. (1 CDRW, 5
drives)

Note two things:

1) All the drives are always reported by BIOS at boot time. Now, that
doesn't guarantee that the drives spin up. It may only mean they can
be read by BIOS, but they are there as far as I can tell. They show up
in the boot screens and in BIOS itself if I drop in to play with
settings.

2) Whatever state the machine comes up in - drives recognized or not -
it will run forever in that state under some pretty heavy loads so it
isn't like the PSU can't completely do the job. It could possibly be
marginal though.

QUESTION: There are some settings in BIOS for delaying the drive. (Or
something. I'm using the machine and not in BIOS) There were settings
from 0 to 35 seconds if I remember correctly. Possibly I should try
setting each drive to a different value to different value to stagger
power up?

If you need more info or have other ideas please let me know.

Thanks,
Mark
