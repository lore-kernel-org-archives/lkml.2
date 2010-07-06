Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085Ab0GFGeA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 02:34:00 -0400
Received: from hera.kernel.org ([140.211.167.34]:47474 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753682Ab0GFGd6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 02:33:58 -0400
Message-ID: <4C32CE50.6010501@kernel.org>
Date: Tue, 06 Jul 2010 08:33:52 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: Mark Knecht <markknecht@gmail.com>
CC: Linux Kernel List <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Drives missing at boot
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>	<4C2F5ECB.1040505@kernel.org>	<AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>	<4C2F61AB.9030806@kernel.org>	<AANLkTilYOT45q8OUJ-_V61_fnYy9HIk6GAv5ZPiomCaT@mail.gmail.com>	<4C317C04.20500@kernel.org> <AANLkTilupyieml9yaWO9BUNPmQQ0g2w1HLWj6R9MwDZf@mail.gmail.com>
In-Reply-To: <AANLkTilupyieml9yaWO9BUNPmQQ0g2w1HLWj6R9MwDZf@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 06 Jul 2010 06:33:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/05/2010 06:56 PM, Mark Knecht wrote:
>>>> dmesg output preferably with printk timestamp enabled.
>>
>> Can you please apply the attached patch, reproduce the problem and
>> post the kernel log?
> 
> I'm sorry. What am I patching? I'm not a kernel developer - not even a
> programmer - so I'll need some help with this. What's the command I
> should use?
> 
> c2stable src # ls -la /usr/src/
> total 32
> drwxr-xr-x  8 root root 4096 Jul  2 09:56 .
> drwxr-xr-x 14 root root 4096 Apr 15 07:46 ..
> -rw-r--r--  1 root root    0 Mar 24 18:37 .keep
> lrwxrwxrwx  1 root root   22 Jul  2 09:56 linux ->
> linux-2.6.34-gentoo-r1
> drwxr-xr-x 23 root root 4096 Jun 16 07:23 linux-2.6.32-gentoo-r7
> drwxr-xr-x 24 root root 4096 Jun 16 08:42 linux-2.6.34-gentoo
> drwxr-xr-x 24 root root 4096 Jul  3 15:30 linux-2.6.34-gentoo-r1
> drwxr-xr-x 21 root root 4096 Jun 27 13:12 linux-2.6.34-rc3
> drwxr-xr-x 20 root root 4096 Jun 15 08:05 linux-2.6.34-rc5
> drwxr-xr-x 20 root root 4096 Jun 27 13:13 linux-2.6.35-rc3

Hmm...

$ cd /usr/src/linux && patch -p1 < PATCH_FILE

should do it.  You know how to build and install the compiled kernel,
right?

Thanks.

-- 
tejun
