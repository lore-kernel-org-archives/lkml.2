Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932636Ab1CRTvw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:51:52 -0400
Received: from lucidpixels.com ([75.144.35.66]:55710 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500Ab1CRTvs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:51:48 -0400
Date: Fri, 18 Mar 2011 15:51:47 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Arnd Bergmann <arnd@arndb.de>
cc: Tim Soderstrom <tim@moocowproductions.org>, linux-usb@vger.kernel.org,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>, flashbench-results@lists.linaro.org
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
In-Reply-To: <201103182033.02793.arnd@arndb.de>
Message-ID: <alpine.DEB.2.02.1103181547590.21715@p34.internal.lan>
References: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan> <201103182010.37455.arnd@arndb.de> <alpine.DEB.2.02.1103181524400.21715@p34.internal.lan> <201103182033.02793.arnd@arndb.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 18 Mar 2011, Arnd Bergmann wrote:

> On Friday 18 March 2011 20:26:46 Justin Piszcz wrote:
>>> The numbers are jumping around a bit with the incorrectly guessed erasesize.
>>> These values should be more like the ones in the first test. Can you rerun
>>> with --erasesize=$[4 * 1024 * 1024]?
>> Hi, I put the box back into production with ext2, if it fails again I can
>> re-run.
>
> Ok. Did you make sure to get the partition table right? It's
> rather tricky with fdisk, since it normally doesn't align
> to 4 MB. You can see this using 'fdisk -l -u /dev/sda'.

Erm, probably not right then..

Disk /dev/sda: 8220 MB, 8220835840 bytes
154 heads, 56 sectors/track, 1861 cylinders, total 16056320 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x99df019d

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1            2048    16056319     8027136   83  Linux

>
>>> Also, what is the output of 'lsusb' for this stick? I'd like to add the
>>> data to https://wiki.linaro.org/WorkingGroups/KernelConsolidation/Projects/FlashCardSurvey
>> Sure,
>> Bus 001 Device 002: ID 0325:ac02 OCZ Technology Inc ATV Turbo / Rally2 Dual Channel USB 2.0 Flash Drive
>>
>
> Added now, thanks!
>
> Do you also have the product name for this?
10007937 OCZ OCZUSBR2TDC-8GB 8GB Rally2 Turbo USB 2.0 Flash Drive Retail
Was $116.99 on 01-05-2009.

Was purported (at the time) to be one of the fastest USB sticks available,
according to benchmarks.


>
> 	Arnd
>
