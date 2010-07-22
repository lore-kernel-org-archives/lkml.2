Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759290Ab0GVMjY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 08:39:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:39776 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753596Ab0GVMjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 08:39:22 -0400
Message-ID: <4C483BF4.3090006@kernel.org>
Date: Thu, 22 Jul 2010 14:39:16 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Mark Knecht <markknecht@gmail.com>
CC: Paul Check <paul@thechecks.ca>,
        Linux Kernel List <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Drives missing at boot
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>	<4C2F5ECB.1040505@kernel.org>	<AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>	<4C2F61AB.9030806@kernel.org>	<AANLkTilYOT45q8OUJ-_V61_fnYy9HIk6GAv5ZPiomCaT@mail.gmail.com>	<4C317C04.20500@kernel.org>	<AANLkTilupyieml9yaWO9BUNPmQQ0g2w1HLWj6R9MwDZf@mail.gmail.com>	<4C32CE50.6010501@kernel.org>	<AANLkTikehTO1j6Gd7Y_g32_P6Yg9KB8Z8qwbNJh10aOU@mail.gmail.com>	<4C341598.6040004@kernel.org>	<AANLkTik4zkcIyVxwtX8GA1BsQSZaAeODpPlY3mRVBc-4@mail.gmail.com>	<4C34A1D5.1090202@kernel.org>	<AANLkTilgQSu3qi7qoTtjnV22r-8Sh1hbDAB_nlPImWNt@mail.gmail.com>	<4C34B8BE.5080504@kernel.org>	<AANLkTilDbrA6lLPSOAtA8_4mLNkUZibHweTliqU5jd03@mail.gmail.com>	<4C44BD42.3030904@kernel.org>	<7141c88bc8c27f26c2187252c0594318.squirrel@thechecks.ca>	<4C45AF40.7030800@kernel.org> <AANLkTinxDjPCk46eItZrXziTbf6efqvNNNTbkZDXIbns@mail.gmail.com>
In-Reply-To: <AANLkTinxDjPCk46eItZrXziTbf6efqvNNNTbkZDXIbns@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 22 Jul 2010 12:39:18 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/21/2010 10:54 PM, Mark Knecht wrote:
>    Looks like I had a failure today. First one in weeks and only the
> 3rd or 4th boot with this newer patch file. One of the two drives
> making a RAID0 wasn't found so /dev/md11 (constructed from /dev/sdd
> and /dev/sde) couldn't be started. I did a cold reboot and the drive
> was found.
> 
>    If it matters, and it probably doesn't, the failure came on a boot
> which had a scheduled fsck to do of /dev/md5 - my main / drive. I
> don't see how that would make a difference but I figure why leave the
> info out. That's why the times are so much larger in the dmesg file.
> (I think)
> 
>    dmesg attached. I patched the Gentoo kernel if it makes a
> difference, same as I did with the earlier patch.
> 
> mark@c2stable ~ $ uname -a
> Linux c2stable 2.6.34-gentoo-r2 #1 SMP PREEMPT Sun Jul 18 14:09:48 PDT
> 2010 x86_64 Intel(R) Core(TM) i7 CPU X 980 @ 3.33GHz GenuineIntel
> GNU/Linux
> mark@c2stable ~ $

Hmmm... that's weird.  Can you please make sure the patch is actually
applied?  Adding a printk("XXX patch applied!\n") near other changes
usually is easy enough.  Also, can you please apply resume-dbg-1.patch
too and reproduce the failure and post log?

Thanks.

-- 
tejun
