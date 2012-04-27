Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757575Ab2D0Xhl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 19:37:41 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:51413 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756534Ab2D0Xhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 19:37:38 -0400
MIME-Version: 1.0
In-Reply-To: <1a0aaa16-df06-40bf-88c7-28180455e6b9@email.android.com>
References: <20120227115905.GB9943@elte.hu>
	<1332974587-15452-1-git-send-email-kjwinchester@gmail.com>
	<4F99A69B.4040004@zytor.com>
	<CAELBVzAi_yndZbDc0TkXhbqzn2wULpnsFMA_dop=Uvaii8tkqg@mail.gmail.com>
	<1a0aaa16-df06-40bf-88c7-28180455e6b9@email.android.com>
Date: Fri, 27 Apr 2012 20:37:36 -0300
Message-ID: <CAELBVzAN33S4_VATnO7FaNjNaObqHsp+OXPsQYeve1N_qUztcA@mail.gmail.com>
Subject: Re: [PATCH v5 0/5] x86: Cleanup and simplify cpu-specific data
From: Kevin Winchester <kjwinchester@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Nick Bowler <nbowler@elliptictech.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Borislav Petkov <bp@alien8.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 April 2012 18:21, H. Peter Anvin <hpa@zytor.com> wrote:
> Against mainline would be better, unless it actively conflicts with something in tip.
>

Alright, my git/make skills must be lacking.  I just checked out
3.4-rc4 to a new branch, and then git cherry-picked my 5 patches onto
that branch.  Then I ran:

$ make ARCH=i386 allnoconfig
$ make ARCH=i386

And the build completed without warnings or errors.  Should that be
equivalent to what you did to build i386 allnoconfig?  If so, then I
wonder why I would not see those problems.

Can anyone offer any advice?

Thanks,

-- 
Kevin
