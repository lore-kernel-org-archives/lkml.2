Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab0JSU3f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 16:29:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:59529 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753408Ab0JSU3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 16:29:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] linux-firmware: Add firmware file for r8712u (RTL8192SU)
Date: Tue, 19 Oct 2010 22:29:30 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7-next-20101015+; KDE/4.5.1; x86_64; ; )
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
References: <4cbdbf3b.Ek+PDAiA1jX27HRq%Larry.Finger@lwfinger.net> <201010191935.40788.arnd@arndb.de> <4CBDE1C1.4020204@lwfinger.net>
In-Reply-To: <4CBDE1C1.4020204@lwfinger.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201010192229.30133.arnd@arndb.de>
X-Provags-ID: V02:K0:lcX3SJJTn291oSDuXG6JYjZOy8SK9yo5Ew1rLCXKMaD
 Y4vaBmhZKMxqhFAbnTz1nA/5sQ/a7al6E/MVRA6uEP8RY3RmSv
 pxXGfNRc1nryoitblKAB/BuNCEngnpqeVsU+w1/zjKgReMHl7r
 HCDSACa7FcMWL5Jz7NEVoCm6F1aRw7fractycoM8zgRVkY4pXa
 c8VmJ7ELKY7I7wGf2YdKg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 October 2010 20:21:53 Larry Finger wrote:
> 
> I was the one that added the drive, including the firmware file, to the kernel.
> I know the driver was developed legally. I took source files that contain a GPL
> license (including the firmware source) from the Realtek public site, cleaned up
> the driver, added a copyright for my changes, and got permission from Realtek to
> submit the result to the staging directory through Greg K-H. 

Ok, so if you have the firmware source, add a proper make file and the source along
with the binary file. You made it sound like the you only had the firmware as
a hexdump, which would not be possible under the GPLv2 section 3, which says
"The source code for a work means the preferred form of the work for making
modifications to it".

> > Hint: some files of the driver contain these "interesting" conditions:
> > 
> > /*
> >  * Copyright(c) 2008 - 2010 Realtek Corporation. All rights reserved.
> >  * Linux device driver for RTL8192U
> >  *
> >  * Based on the r8187 driver, which is:
> >  * Copyright 2004-2005 Andrea Merello <andreamrl@tiscali.it>, et al.
> >  * This program is free software; you can redistribute it and/or modify it
> >  * under the terms of version 2 of the GNU General Public License as
> >  * published by the Free Software Foundation.
> 
> That Merello copyright really has little to do with the current driver. As
> Realtek included it in their source, I left it in, but consider it to be an
> honorary citation.

That part is fine, what is not fine is the "All rights reserved" portion, which
contradicts the GPL.

	Arnd
