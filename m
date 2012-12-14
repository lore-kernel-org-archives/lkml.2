Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757073Ab2LNSZ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 13:25:59 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:35930 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756992Ab2LNSZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 13:25:57 -0500
MIME-Version: 1.0
In-Reply-To: <23916.1355356085@warthog.procyon.org.uk>
References: <201212122211.qBCMBRxl027895@terminus.zytor.com> <23916.1355356085@warthog.procyon.org.uk>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 14 Dec 2012 10:25:36 -0800
X-Google-Sender-Auth: 6BsfgZbAuYrK_S7Mn46yGj0aW7I
Message-ID: <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
Subject: Re: [GIT PULL] x86/uapi for 3.8
To: David Howells <dhowells@redhat.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Arnd Bergmann <arnd@arndb.de>,
        Dave Jones <davej@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 12, 2012 at 3:48 PM, David Howells <dhowells@redhat.com> wrote:
> H. Peter Anvin <hpa@linux.intel.com> wrote:
>
>> The following changes since commit 7e5530af11be68f3109672aed59243f82e1272f0:
>>
>>   Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2012-12-02 16:39:00 -0800)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-uapi-for-linus
>
> Unfortunately, that is broken by Al Viro's mass signalling changes.  I've
> regenerated it based on Linus's current master.  Pull request below.
>
> The same merge conflict with tip/master still exists, I imagine, due to the
> changes in tipbot for asm/mce.h, so if tip/master is merged first, then it
> might be worth me regenerating my changes.

Yeah, I think I have most of the x86 stuff merged now (just merged the
EFI and ACPI trees), and at this point it might be worth regenerating
it and getting this over and done with.

          Linus
