Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751351Ab1IYGLU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Sep 2011 02:11:20 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:33674 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab1IYGLS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Sep 2011 02:11:18 -0400
MIME-Version: 1.0
Reply-To: mtk.manpages@gmail.com
In-Reply-To: <CAK1hOcPFXMoYsP6N6Hx5Qz3J4xj31TmSj7xo6SRVPegNCbhx7g@mail.gmail.com>
References: <CAK1hOcPFXMoYsP6N6Hx5Qz3J4xj31TmSj7xo6SRVPegNCbhx7g@mail.gmail.com>
From: Michael Kerrisk <mtk.manpages@gmail.com>
Date: Sun, 25 Sep 2011 08:10:58 +0200
Message-ID: <CAKgNAkipqzQRt1AGDvgMZ7mRiMjqASP6+z-GuHUPEhdS4Jh_KQ@mail.gmail.com>
Subject: Re: [PATCH] man ptrace: add extended description of various ptrace quirks
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-man <linux-man@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Denys,

On Thu, Jul 21, 2011 at 1:09 PM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
> Hi Michael,
>
> Please apply attached patch which updates ptrace manpage.
> (I'm not sending it inline, google web mail might mangle it. Sorry).

Thanks. This is a fantastic piece of work! I'm working on the patch
now; it'll probably take me a few days before I have done with it.
I'll send you the new version for review when I'm done.

> Changes include:
>
> s/parent/tracer/g, s/child/tracee/g - ptrace interface now
> is sufficiently cleaned up to not treat tracing process as parent.
>
> Deleted several outright false statements:
> - pid 1 can be traced

For changes like this, it's useful to record when the change occurred,
rather than just deleting the old text. I'm taking it that the change
occurred in 2.6.26, with commit
00cd5c37afd5f431ac186dd131705048c0a11fdb. Right?

> - tracer is not shown as parent in ps output

Was this a change triggered by a kernel revision? If so, which kernel version?

> - PTRACE_ATTACH is not "the same behavior as if tracee had done
>  a PTRACE_TRACEME": PTRACE_ATTACH delivers a SIGSTOP.

Again, was this a change triggered by a kernel revision? If so, which
kernel version?

> - SIGSTOP _can_ be injected.

Again, was this a change triggered by a kernel revision? If so, which
kernel version?

> - Removed mentions of SunOS and Solaris as irrelevant.

Yes, seems fair enough to me.

> - Added a few more known bugs.

Thanks.

> Added a large block of text in DESCRIPTION which doesn't focus
> on mechanical description of each flag and operation, but rather
> tries to describe a bigger picture. The targeted audience is
> a person which is reasonably knowledgeable in Unix but did not
> spend years working with ptrace, and thus may be unaware of its quirks.
> This text went through several iterations of review by Oleg Nesterov
> and Tejun Heo.

Really, really good that you added that. Thank you.

> This block of text intentionally uses as little markup as possible,
> otherwise future modifications to it will be very hard to make.

Sorry, here I have to disagree ;-). Maintaining consistency across the
almost 1000 pages in man-pages is important for many reasons:
* Reader comfort; all man pages should look fairly consistent.
* Some scripts rely on consistent formatting to produce nicely rendered output
* Some global edits and replaces, and checking scripts, are more
likely to work well when formatting is consistent
* Consistent formatting probably also is helpful for downstream translations.

So, for these reasons, mark-up really should be applied. I'll do that
now, and if you need assistance with mark-up for future revisions, I'm
very happy to help out.

Cheers,

Michael

-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Author of "The Linux Programming Interface"; http://man7.org/tlpi/
