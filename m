Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758658Ab2EUVE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 17:04:29 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:59944 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab2EUVE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 17:04:27 -0400
MIME-Version: 1.0
In-Reply-To: <1337631255.13812.36.camel@joe2Laptop>
References: <1337629490-7446-1-git-send-email-nasirabed+kernel@gmail.com>
	<1337631255.13812.36.camel@joe2Laptop>
Date: Mon, 21 May 2012 23:04:27 +0200
X-Google-Sender-Auth: 36XhLhCY3f6K0bw_uBuYkF-vI0c
Message-ID: <CAMXkaZEhDaj_qtPp8wu315HD1Nw_nK88cuZ1_jpaWqf8y1qvow@mail.gmail.com>
Subject: Re: [PATCH] Staging: android: alarm: Renamed pr_alarm to alarm_dbg
From: Nasir Abed <nasirabed+kernel@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

> Welcome to linux-kernel developing.
>
Thanks.

> It's generally pretty unnecessary to resubmit a variant of
> a patch that someone else has already submitted.
>
My mistake I should have double checked that first.

> If you want to get your 2nd patch in, that's great, but
> please consider doing work that isn't just checkpatch
> cleanups and isn't duplicative of work where you were cc'd.
>
That doesn't really sounds encouraging. Greg Kroah-Hartman
presentation on writing and submitting your (first) patch was my
inspiration to start helping out. However what you are saying might
scare away potential new developers.

> diff --git a/drivers/staging/android/alarm.c b/drivers/staging/android/alarm.c
>
> Is this done against -next or some other -staging tree?
>
I am using: http://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git

Thanks for your feedback, very helpful.

Cheers,

Nasir Abed
