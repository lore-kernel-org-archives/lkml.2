Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754424Ab0LJH4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 02:56:01 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:44600 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1754066Ab0LJH4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 02:56:00 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+B250fxbqBZ/9VxPJekPxZ7lxY83dLHWNzAJXeBk
	5lghovHYN3KIar
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] mfd/wm831x-irq: Convert to new irq_chip functions and fix build failure
Date: Fri, 10 Dec 2010 08:55:51 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36; KDE/4.4.5; x86_64; ; )
Cc: Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Stable <stable@kernel.org>
References: <1291937687-20243-1-git-send-email-peterhuewe@gmx.de> <12ABA93B-6923-4AF7-BF34-E070BE72A8E2@opensource.wolfsonmicro.com>
In-Reply-To: <12ABA93B-6923-4AF7-BF34-E070BE72A8E2@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012100855.51446.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 10 Dezember 2010, 02:09:00 schrieb Mark Brown:
> > Cc: Stable <stable@kernel.org>
> 
> Why are you CCing to stable? This API was only introduced in 2.6.37 which
> is still in -rc and attempting to backport to stable releases would cause
> those releases to fail to build.

The driver obviously fails since October 30 in linus tree [1], that's why I 
thought it might still have gone into .36
If not I'm sorry about the cc.

Seems like I got a little confused about that - sorry.
I'm doing this only in my leisure time and tracking the whole lkml and 
subprojects is quite a lot ;) 
I'm doing my usual checks with git, but sometimes things slip.

It seems the right thing for me to drop that patch at this time, since there 
is some actual development going on here. 
(I just don't like build failures in Linus' tree ;)

But I'd like to add that there are still many other drivers, especially in 
mtd, which still break - but mark already seems to have them on his list.


Peter

References:
[1] http://kisskb.ellerman.id.au/kisskb/buildresult/3423418/
[2] http://kisskb.ellerman.id.au/kisskb/buildresult/3607680/





