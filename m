Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010Ab2JWPBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 11:01:17 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45494 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932821Ab2JWPBQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 11:01:16 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <20121023110626.GA28620@gmail.com>
References: <20121023110626.GA28620@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [GIT PULL] x86 fix
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Tue, 23 Oct 2012 08:00:54 -0700
To: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Message-ID: <74b2df09-a93c-4593-94f8-0284fd9fcab5@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I thought I had already pushed this fix with a proper description...

Ingo Molnar <mingo@kernel.org> wrote:

>Linus,
>
>Please pull the latest x86-urgent-for-linus git tree from:
>
>git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git
>x86-urgent-for-linus
>
>HEAD: 235d220e1b55c1f8683fd4f59c3e8e39ba6ca915 Merge tag
>'numascale_mce_fix' of
>git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras into x86/urgent
>
>Fix for a system with an atypical use of AMD CPUs.
>
> Thanks,
>
>	Ingo
>
>------------------>
>Daniel J Blueman (1):
>      x86, AMD, MCE: Prevent oops on multi-server system

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
