Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab2E0Ljy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 07:39:54 -0400
Received: from saturn.retrosnub.co.uk ([178.18.118.26]:60040 "EHLO
	saturn.retrosnub.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab2E0Ljx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 07:39:53 -0400
Message-ID: <4FC22098.3070803@kernel.org>
Date: Sun, 27 May 2012 13:39:52 +0100
From: Jonathan Cameron <jic23@kernel.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: swarren@wwwdotorg.org, kay.sievers@vrfy.org,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: arm: Remaining issue with alignment of __log_buf in printk.c
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi All,

My stargate 2 board refused to start and after bisection I ended
up at the same patch that Stephen found an alignment issue in.
Unfortunately Stephen's patch doesn't seem to have fixed the
issue for me.
https://lkml.org/lkml/2012/5/10/510 is the thread.  Patch from
Stephen is : f8450fca6ecdea38b5a882fdf6cd097e3ec8651c

Increasing the alignement for 32 bit systems to 8 seems to do the
job but I can't immediately think why...

System is a pxa27x strong arm.

Tree was effectively today's mainline.

Saddly I have too many other bits to fit in today for futher
investigation (hence this information free email!)


Jonathan
