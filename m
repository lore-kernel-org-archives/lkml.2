Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762032Ab0HFUZq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 16:25:46 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46262 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752473Ab0HFUZn convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 16:25:43 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1008060016300.3225@localhost.localdomain>
References: <alpine.LFD.2.00.1008060016300.3225@localhost.localdomain>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 6 Aug 2010 13:25:22 -0700
Message-ID: <AANLkTi=UXQ2EfSNNAudHeEGybaNJpzz6ku8RcfRzOpct@mail.gmail.com>
Subject: Re: [GIT pull] timekeeping updates for 2.6.36
To: Thomas Gleixner <tglx@linutronix.de>, Paul Mackerras <paulus@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 3:19 PM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Please pull the latest timers-timekeeping-for-linus git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-timekeeping-for-linus
>
> It contains two cherry-picks from the powerpc tree which have changes
> in the same area of code. John Stultz selected them with the powerpc
> folks to avoid complex fixups in next.

Well, it just resulted in another merge conflict, but I resolved it
the same way you had resolved your cherry-picks. However, I wanted to
let people know, so that the powerpc guys can re-verify that whole
vsyscall timer change.

So Paul, Ben, please check out that I didn't screw something up in there.

                Linus
