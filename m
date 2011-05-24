Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784Ab1EXF7L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:59:11 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41519 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752511Ab1EXF7I convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:59:08 -0400
MIME-Version: 1.0
In-Reply-To: <20110523193035.GA9170@elte.hu>
References: <20110523193035.GA9170@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 May 2011 22:58:13 -0700
Message-ID: <BANLkTimUr+2k3_RAyncLX5yFYeV5JaJDsQ@mail.gmail.com>
Subject: Re: [GIT PULL] more x86/apic changes for v2.6.40
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 12:30 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Please pull the latest x86-apic-for-linus git tree from:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git x86-apic-for-linus

Hmm. Right now my bisect is going (and on that slow atom thing I'm
just about to give up for the evening and continue tomorrow), but it
*looks* like this pull breaks resume on my eeepc netbook.

I've bisected it down to three merges:
 - sched-core-for-linus (looks unlikely)
 - 'for-linus' of master.kernel.org:/home/rmk/linux-2.6-arm
 - x86-apic-for-linus (I don't see anything wrong, but it seems to be
the most likely of the three)

Any idea why anything there would break resume?

                          Linus
