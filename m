Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756598Ab2ICUHj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 16:07:39 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:41841 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756395Ab2ICUHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 16:07:38 -0400
MIME-Version: 1.0
X-Google-Sender-Delegation: a3at.mail@gmail.com
In-Reply-To: <CAAW1UO9yLVi8JnYBc8UP_1FDU0wUWSS33x62H-tk0qkK_PWWwA@mail.gmail.com>
References: <CAAW1UO-q5uUe4zG5BnB0z9dyKCqRRWH4sriyu7Fj6XinE7GKzA@mail.gmail.com>
	<CAAW1UO9yLVi8JnYBc8UP_1FDU0wUWSS33x62H-tk0qkK_PWWwA@mail.gmail.com>
Date: Tue, 4 Sep 2012 00:07:37 +0400
X-Google-Sender-Auth: 6HkW_hos6Jxo4Gjz3ctO6w2P_k8
Message-ID: <CAAW1UO_y2bHVQWpcqrZcZbFAc=V_E1iLcTHD6g1X=NTAaKTfeg@mail.gmail.com>
Subject: Re: western digital caviar black. EXT4-fs error
From: Azat Khuzhin <dohardgopro@gmail.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anybody?

On Sat, Sep 1, 2012 at 11:53 PM, Azat Khuzhin <dohardgopro@gmail.com> wrote:
> I'v also post question here
>
> http://serverfault.com/questions/423565/western-digital-caviar-black-ext4-fs-error
>
> On Sat, Sep 1, 2012 at 11:48 PM, Azat Khuzhin <dohardgopro@gmail.com> wrote:
>> Recently I update my HDD on desktop machine, and bought WD Caviar Black.
>> But after I format & copy information to it (using dd), and fix
>> partitions size: I have next errors in kern.log:
>>
>> Aug 28 01:49:03 home-spb kernel: [183245.030897] EXT4-fs error (device
>> sdc2): ext4_mb_generate_buddy:739: group 3675, 32254 clusters in
>> bitmap, 32258 in gd
>> Aug 28 01:49:03 home-spb kernel: [183245.030956] EXT4-fs error (device
>> sdc2): ext4_mb_generate_buddy:739: group 4181, 32254 clusters in
>> bitmap, 32258 in gd
>> Aug 28 01:49:03 home-spb kernel: [183245.030980] EXT4-fs error (device
>> sdc2): ext4_mb_generate_buddy:739: group 2600, 32254 clusters in
>> bitmap, 32258 in gd
>> Aug 28 01:49:03 home-spb kernel: [183245.061866] EXT4-fs error (device
>> sdc2): ext4_mb_generate_buddy:739: group 9305, 32254 clusters in
>> bitmap, 32258 in gd
>> Aug 28 01:49:03 home-spb kernel: [183245.061892] EXT4-fs error (device
>> sdc2): ext4_mb_generate_buddy:739: group 8230, 32254 clusters in
>> bitmap, 32258 in gd
>> Aug 28 01:49:40 home-spb kernel: [183281.733813] EXT4-fs error (device
>> sdc2): ext4_mb_generate_buddy:739: group 2477, 32254 clusters in
>> bitmap, 32258 in gd
>> Aug 28 01:49:40 home-spb kernel: [183281.743131] JBD2: Spotted dirty
>> metadata buffer (dev = sdc2, blocknr = 0). There's a risk of
>> filesystem corruption in case of system crash.
>> Aug 28 01:50:13 home-spb kernel: [183314.898637] EXT4-fs error (device
>> sdc2): ext4_mb_generate_buddy:739: group 3139, 32254 clusters in
>> bitmap, 32258 in gd
>> Aug 28 01:50:58 home-spb kernel: [183359.783544] EXT4-fs error (device
>> sdc2): ext4_mb_generate_buddy:739: group 4061, 32254 clusters in
>> bitmap, 32258 in gd
>> Aug 28 01:50:58 home-spb kernel: [183359.783577] EXT4-fs error (device
>> sdc2): ext4_mb_generate_buddy:739: group 8166, 32254 clusters in
>> bitmap, 32258 in gd
>> Aug 28 01:51:08 home-spb kernel: [183369.757927] EXT4-fs error (device
>> sdc2): ext4_mb_generate_buddy:739: group 8171, 32254 clusters in
>> bitmap, 32258 in gd
>> Aug 28 16:06:54 home-spb kernel: [234584.906721] EXT4-fs (sdc2): error count: 26
>> Aug 28 16:06:54 home-spb kernel: [234584.906725] EXT4-fs (sdc2):
>> initial error at 1346069075: ext4_mb_generate_buddy:739
>> Aug 28 16:06:54 home-spb kernel: [234584.906727] EXT4-fs (sdc2): last
>> error at 1346104268: ext4_mb_generate_buddy:739
>>
>> One time, machine rebooted (not manually), when I turn it on, it runs
>> fsck on /dev/sdc2 and fix some errors and some files are missing on
>> /dev/sdc2
>>
>> I'v check /dev/sdc2 for badblocks, it doesn't have it ( using e2fsck
>> -c /dev/sdc2 )
>> Here is the output of fsck http://pastebin.com/D5LmLVBY
>>
>> What else I can do to understand what's wrong here?
>>
>> BTW for /dev/sdc1 no message like that, in kern.log
>>
>> Linux version: 3.3.0
>> Distributive: Debian wheezy
>>
>> --
>> Azat Khuzhin
>
>
>
> --
> Azat Khuzhin



-- 
Azat Khuzhin
