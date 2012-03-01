Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab2CAAMk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 19:12:40 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:61471 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755876Ab2CAAMj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 19:12:39 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of keith.chew@gmail.com designates 10.101.133.11 as permitted sender) smtp.mail=keith.chew@gmail.com; dkim=pass header.i=keith.chew@gmail.com
MIME-Version: 1.0
In-Reply-To: <87zkc1w6wp.fsf@xmission.com>
References: <CAKaWdxZGg-Xpw2E85bAr8BVgWtXxEitwsir=yXp5qS0FMUk1uQ@mail.gmail.com>
	<m1ehtd8qez.fsf@fess.ebiederm.org>
	<CAKaWdxbuwV6yQnX=4zcBZncL8f+7cXPFwx8ejw=6d=dX8NoZsw@mail.gmail.com>
	<87obshxt4w.fsf@xmission.com>
	<CAKaWdxa326eP47=nENh8_1NmRCadTB=o8jyWO2dAzZcn9yCwiA@mail.gmail.com>
	<87zkc1w6wp.fsf@xmission.com>
Date: Thu, 1 Mar 2012 13:12:38 +1300
Message-ID: <CAKaWdxa8yJJhnPj1th6GdYvn9+Lu7GUV1e=960gMQOdc8W47dQ@mail.gmail.com>
Subject: Re: Hang on "echo b > /proc/sysrq-trigger"
From: Keith Chew <keith.chew@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric

> I would check with your BIOS folks and perhaps play with the kernel
> option.  The most reliable way to peform a reset is to trigger a board
> reset by writing to 0xcf9 or a similar register.  I expect your BIOS
> does that and you can probably get the kernel to do that.  I would
> definitely test to see if you can write to the mostly standard
> 0xcf9 register directly from the kernel and trigger a reset directly.
>
> Once past a reset and with a single cpu all of the failures will be
> happening in the boot path.  So the only possible points of failure
> are in devices that are different between a soft reset and a power on
> reset.
>
> I would check to see if your board perhaps supports post codes or any
> other debugging that will let you see where you are hanging.
>
> It sounds like there is some very rare failure, that is going to be
> a challenge to track down.  I would definitely test more than one
> motherboard to ensure that you can reproduce the problem on more
> than one piece of hardware.  Sometimes hardware is just broken.
>

These are really helpful suggestions, I will try to get to the bottom
on it. Yes, have tried 3 different boards with different RAM, HDD and
CPU. The hang can be reproduced consistently (just not
deterministically at this stage).

Thank you very much again, will update the progress in due course.

Regards
Keith
