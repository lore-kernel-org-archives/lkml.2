Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932902Ab2FAApl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 20:45:41 -0400
Received: from mail.candelatech.com ([208.74.158.172]:56425 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932658Ab2FAApk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 20:45:40 -0400
Message-ID: <4FC810B3.5040208@candelatech.com>
Date: Thu, 31 May 2012 17:45:39 -0700
From: Ben Greear <greearb@candelatech.com>
Organization: Candela Technologies
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: valdis.kletnieks@vt.edu
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Anyone successfully booted a custom kernel on Fedora 17?
References: <4FC6B85C.20201@candelatech.com>            <4FC6E257.4070608@candelatech.com> <23353.1338510488@turing-police.cc.vt.edu>
In-Reply-To: <23353.1338510488@turing-police.cc.vt.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 05:28 PM, valdis.kletnieks@vt.edu wrote:
> On Wed, 30 May 2012 20:15:35 -0700, Ben Greear said:
>> On 05/30/2012 05:16 PM, Ben Greear wrote:
>>> This is probably a Fedora 17 issue..but hoping someone will have mercy on me :)
>>
>> Must be something to do with my kernel config or how I generate
>> the initrd with mkinitrd:
>
> For what it's worth, over on the Rawhide side of the fence, dracut-018-74
> builds bad initramfs images for me,while dracut-081-53 works.  Not sure
> what release is in the F17 updates repository.  I'm going to file a bug report
> with Fedora soon as I figure out what -74 is doing wrong.

At least my problem appears to be some missing feature in the kernel, probably
one of the 'fooFS' things releated to ramdisk and/or early startup.
I enabled several things I found in the F17 .config file that were not in my
config file, and now my kernel boots, at least when I
build and install it on the F17 machine.

I'm going to try building on F13 and just (re)making the initrd on
F17 like I have been for all other distributions, but that will be
a day or two..got a release to shove out the door first!

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

