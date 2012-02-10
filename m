Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760849Ab2BJXC4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 18:02:56 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:50642 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906Ab2BJWoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 17:44:16 -0500
From: Martin Rogge <marogge@onlinehome.de>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux thread scheduling
Date: Fri, 10 Feb 2012 23:44:12 +0100
User-Agent: KMail/1.13.6 (Linux/3.2.4-ck1; KDE/4.5.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201202102344.12509.marogge@onlinehome.de>
X-Provags-ID: V02:K0:mD+Mhk9QDPpD8SFo1AjbYSNpxcqS/p6yHUsnRumIvTV
 eX+A5M5nl9psugu36R+mNlv8fHUP0jd/9BD0MwbZKWJtroqoK5
 98GW0X9VNA8z5ATsUlyK+YYgk7AdXFlPUKUe6pGSS7uxkLhPS/
 Hft4laLJPgK1ncDONFK5F0PXejQuzPloXGUylNu2GBj5fDgqz9
 LWtBWDKvZPpcw1oBNoPsYuxqX5mbhy0NqPAyPwZjkgTuuSj7Ex
 YeP/W5d/API3NSJHO7NBrU4sM8gPudpBeRlmA5xjzrgTkcbUPd
 LddxIts2MYgTsYuGBt4vlmFSw1ckFUAr3f9HLiZFMz6h+FCqw0
 fOCJ88H/ZGH5LaF9Kd+9tgq2LVnTE1FptOzcaFFZQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xin Tong wrote:

> I have a program that spawns 3 threads and there is a great deal of
> sharing among the three threads. they all read/update a couple of
> shared variables.
> 
> I run this on nehalem (8 cores, 4 core in each physical package),  I
> find that running the 3 threads on core 0, 1, 2 (using
> pthread_setaffinitiy) gives much better results, this is because the
> cache coherency protocol performs much better on the same package.
> However, if  I leave Linux (Suse Enterprise) to schedule it. it gives
> much worse performance, i suspect that linux is scheduling the 3
> threads across the physical packages ( 2 on one package, 1 on
> another). Is this possible ? why does linux do this ?

the following paper on cpu schedulers was posted recently. Maybe it gives you 
a starting point.

http://research.cs.wisc.edu/wind/Publications/meehean-thesis11.html
