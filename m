Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752837Ab1EXGJ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:09:58 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60932 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752082Ab1EXGJ5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:09:57 -0400
MIME-Version: 1.0
In-Reply-To: <20110524060321.GA20904@elte.hu>
References: <20110523193035.GA9170@elte.hu> <BANLkTimUr+2k3_RAyncLX5yFYeV5JaJDsQ@mail.gmail.com>
 <20110524060321.GA20904@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 23 May 2011 23:09:05 -0700
Message-ID: <BANLkTin+Ri0RcemY6S77iZ+rZcpPHueyTw@mail.gmail.com>
Subject: Re: [GIT PULL] more x86/apic changes for v2.6.40
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Daniel J Blueman <daniel.blueman@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 11:03 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> Possibly the resume fix in the APIC merge :-/

Well, that's certainly in the right area..

> It's these commits:
>
>  31dce14a3269: x86, ioapic: Use ioapic_saved_data while enabling intr-remapping
>  4c79185cdb14: x86, ioapic: Allocate ioapic_saved_data early
>  b64ce24daffb: x86, ioapic: Fix potential resume deadlock

Those are all in my bisect window, yes. But because it now jumped into
that branch, all the header files changed, and it will take forever to
compile on that machine (I used to do a "build image on my main
machine, copy it over" when I got really fed up with bisecting
multiple things, but now I'm doing it on that machine itself)

I'll get it fully bisected tomorrow, in the meantime maybe Daniel and
Suresh can think about their patches and see if they come up with
something.

                    Linus
