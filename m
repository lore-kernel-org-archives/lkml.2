Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759200Ab2EUVPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:15:45 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42384 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759168Ab2EUVPo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:15:44 -0400
Message-ID: <1337634941.13812.42.camel@joe2Laptop>
Subject: Re: [PATCH] Staging: android: alarm: Renamed pr_alarm to alarm_dbg
From: Joe Perches <joe@perches.com>
To: Nasir Abed <nasirabed+kernel@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Date: Mon, 21 May 2012 14:15:41 -0700
In-Reply-To: <CAMXkaZEhDaj_qtPp8wu315HD1Nw_nK88cuZ1_jpaWqf8y1qvow@mail.gmail.com>
References: <1337629490-7446-1-git-send-email-nasirabed+kernel@gmail.com>
	 <1337631255.13812.36.camel@joe2Laptop>
	 <CAMXkaZEhDaj_qtPp8wu315HD1Nw_nK88cuZ1_jpaWqf8y1qvow@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-21 at 23:04 +0200, Nasir Abed wrote:
> I am using: http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

A couple bits of advice:

Please read Documentation/development-process

When doing cleanup work, always start with the latest
next-YYYYMMDD tagged entry in Stephen Rothwell's -next tree
http://git.kernel.org/?p=linux/kernel/git/next/linux-next.git;a=summary

This is old and out-of-date, but it contains some clues
how -next works.
http://linux.f-seidel.de/linux-next/pmwiki/pmwiki.php?n=Linux-next.FAQ

cheers, Joe

