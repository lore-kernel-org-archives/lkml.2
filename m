Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab2B2WGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 17:06:55 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38467 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932171Ab2B2WGy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 17:06:54 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of keith.chew@gmail.com designates 10.236.155.6 as permitted sender) smtp.mail=keith.chew@gmail.com; dkim=pass header.i=keith.chew@gmail.com
MIME-Version: 1.0
In-Reply-To: <87obshxt4w.fsf@xmission.com>
References: <CAKaWdxZGg-Xpw2E85bAr8BVgWtXxEitwsir=yXp5qS0FMUk1uQ@mail.gmail.com>
	<m1ehtd8qez.fsf@fess.ebiederm.org>
	<CAKaWdxbuwV6yQnX=4zcBZncL8f+7cXPFwx8ejw=6d=dX8NoZsw@mail.gmail.com>
	<87obshxt4w.fsf@xmission.com>
Date: Thu, 1 Mar 2012 11:06:53 +1300
Message-ID: <CAKaWdxa326eP47=nENh8_1NmRCadTB=o8jyWO2dAzZcn9yCwiA@mail.gmail.com>
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

>
> Historically a lot of issues have had to do with which cpu you are
> entering the bios from.  So you might try pinning your process
> to differen cpus and see if you can make the failure more deterministic.
>

We are using a Celeron 575 uniprocessor, so we do not have the option
to pin on another cpu. I have tried compiling the kernel in both UP
and SMP configuration, but sadly both causes the hang.

>
> Ugh.  The other possibility is that there is an intermittent failure in
> the hardware, that prevents the boot/reboot.  Wrong values on pull-up
> resistors have been known to cause that kind of thing.
>

Thank you very much for this pointer, will feed that back to the
manufacturer and see if it will give them some clues. The original
purpose for this reboot exercise was to ensure the software will
handle a power failure without any OS/data corruptions. With this new
discovery of unreliable reboot, the next worry is "If reboot is not
reliable, is the boot process also susceptible to the same issue?". I
have not rigged up any hardware to simulate a periodic full shutdown
and boot up process, but will be planning to set this up next.

Thanks again, if you have any other suggestions for us to try, I am all ears!

Regards
Keith
