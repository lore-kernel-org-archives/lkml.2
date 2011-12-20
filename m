Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab1LTX1r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 18:27:47 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:57590 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab1LTX1o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 18:27:44 -0500
MIME-Version: 1.0
In-Reply-To: <4EEFD926.3040201@am.sony.com>
References: <4EEFD926.3040201@am.sony.com>
Date: Wed, 21 Dec 2011 08:27:42 +0900
Message-ID: <CABiHV1Q2SyXX3h99tAo6Z4tmd1HUsj0KaQB5OV3qqm4Yn8P2ag@mail.gmail.com>
Subject: Re: Android mainlining project
From: Geunsik Lim <leemgs1@gmail.com>
To: Tim Bird <tim.bird@am.sony.com>
Cc: linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 20, 2011 at 9:39 AM, Tim Bird <tim.bird@am.sony.com> wrote:
> Hello all,
>
> I would like to announce the beginning of a project to
> make a concerted effort to mainline patches and features
> from Android into the mainline Linux kernel.
>
> At the recent kernel summit in Prague, there was a discussion
> about re-evaluating some of the Android-specific features
> that are found in Google's android kernel, and looking at
> whether and how to incorporate them into the mainline (kernel.org)
> kernel.
>
> Various parties, including individual developers, the
> CE workgroup in the Linux Foundation, and a group at Linaro
> have been working on different aspects of this.  A wiki
> page and mailing list have been created to help coordinate
> our efforts and avoid duplication and confusion.
>
> The wiki page for this effort (still under construction) is
> at: http://elinux.org/Android_Mainlining_Project
Actually, current linux-next tree is not including ashmem(anonymous
shared memory).
When I checked android kernel features of linux-next(20111219),
Wakelock API feature(./kernel/power/*lock.c) still isn't appeared in
linux-next tree.

>
> There's a mailing list if you wish to follow discussions
> about this project.  It's available at:
> https://lists.linuxfoundation.org/mailman/listinfo/ce-android-mainline
>
> If you are interested in this work, please join the mailing
> list or send me an e-mail.  Some interesting things are already
> happening.  I'll send a status message to the ce-android-mainline
> list in a day or two to let interested parties know what's currently
> going on.
>
> Regards,
>  -- Tim
>
> =============================
> Tim Bird
> Architecture Group Chair, CE Workgroup of the Linux Foundation
> Senior Staff Engineer, Sony Network Entertainment
> =============================
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/



-- 
Best regards,
Geunsik Lim ( Samsung Electronics )
Blog : http://blog.naver.com/invain/
Homepage: http://leemgs.fedorapeople.org
--
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/
