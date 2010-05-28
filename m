Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab0E1Se2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 14:34:28 -0400
Received: from mvp.visionpro.com ([63.91.95.2]:2152 "EHLO
	mvpexchange120.machinevisionproducts.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751678Ab0E1Se1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 14:34:27 -0400
User-Agent: Microsoft-Entourage/12.24.0.100205
Date: Fri, 28 May 2010 11:34:25 -0700
Subject: Slow Disk I/O
From: "Brian D. McGrew" <brian@visionpro.com>
To: <linux-kernel@vger.kernel.org>
Message-ID: <C8255AC1.18B68%brian@visionpro.com>
Thread-Topic: Slow Disk I/O
Thread-Index: Acr+lGXMpv9Xq7EQPUO6EkQ0K1VVzQ==
Mime-version: 1.0
Content-type: text/plain;
	charset="ISO-8859-1"
Content-transfer-encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Good morning All!

I¹m running CentOS 5.4 x86_64 on a Dell T5500 with 3GB || 12GB or RAM. I¹m
running a 2.6.18-128.el5 kernel.  There is a 500GB SATA drive connected to
the onboard SATA controller.  I can reproduce this problem with CentOS 5.4
i386 on the Dell T5500, T5400 and Optiplex 740¹s.

So now, on to the problem...  In our software, we¹re reading in 5MP image
files in the neighborhood of 500 to 1500 files at a time.  Just a simple
for() loop, open, read, close...  Nothing fancy...

When I have 3GB of RAM in the system, life is good.. Each read takes 8 to
10ms...  This is a good thing!

If I bump the memory up to 12GB, all of the reads are now taking 150 to
200ms.

My default, va.swappines to set to 60...  If I decrease this number, the
problem gets much worse.  If I up va.swappines to 100, the problem gets a
little better, but not a whole lot.

What should I be looking at???

-b

