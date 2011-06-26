Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755194Ab1FZUlN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 16:41:13 -0400
Received: from mail.sambodha.org ([87.118.110.134]:62298 "EHLO
	mail.sambodha.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab1FZUkw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 16:40:52 -0400
X-Greylist: delayed 965 seconds by postgrey-1.27 at vger.kernel.org; Sun, 26 Jun 2011 16:40:52 EDT
From: Michael Brade <brade@informatik.uni-muenchen.de>
Organization: =?iso-8859-1?q?Ludwig-Maximilians-Universit=E4t?= 
 =?iso-8859-1?q?_M=FCnchen?=
To: linux-kernel@vger.kernel.org
Subject: 2.6.39.x: utsrelease.h contains "CHK include/generated/utsrelease"
Date: Sun, 26 Jun 2011 22:24:20 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39.1-grsec; KDE/4.6.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201106262224.20679.brade@informatik.uni-muenchen.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I repeatedly get garbled output in utsrelease.h when compiling my own kernel. 
To reproduce:

make mrproper
make allnoconfig
make prepare

Output of "cat include/generated/utsrelease.h":
  CHK     include/generated/utsrelease

I am using linux-2.6.39.2 (stable git branch) with grsec-2.2.2 patch but it 
also happens on 2.6.32.41 with xen and 2.6.39. I have searched with Google a 
lot but I have never found an answer and only very few people seem to ever 
post this problem.

What is driving me nuts is that it works *sometimes* and I don't even know 
when. I am using Debian unstable (amd64), and I have had the problem for a few 
months now, at least since April.

Any ideas what's going on? Do you need any more info? Or do you have some 
hints about how to debug this?

Please CC me.

thanks a lot,
  Michael

