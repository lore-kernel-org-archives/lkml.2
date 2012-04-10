Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082Ab2DJTNE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 15:13:04 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:56749 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758369Ab2DJTNB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 15:13:01 -0400
MIME-Version: 1.0
In-Reply-To: <20120406124921.5754e941.akpm@linux-foundation.org>
References: <1333051320-30872-1-git-send-email-wad@chromium.org>
	<1333051320-30872-2-git-send-email-wad@chromium.org>
	<20120406124921.5754e941.akpm@linux-foundation.org>
Date: Tue, 10 Apr 2012 14:12:55 -0500
Message-ID: <CABqD9hYOJZ5ZZ-8W03d=_BQ2mkdNLbrC2=r6qUrnqsaub3kPCA@mail.gmail.com>
Subject: Re: [PATCH v17 01/15] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent execve
 from granting privs
From: Will Drewry <wad@chromium.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        luto@mit.edu, eparis@redhat.com, serge.hallyn@canonical.com,
        djm@mindrot.org, scarybeasts@gmail.com, indan@nul.nu,
        pmoore@redhat.com, corbet@lwn.net, eric.dumazet@gmail.com,
        markus@chromium.org, coreyb@linux.vnet.ibm.com, keescook@chromium.org,
        jmorris@namei.org, Andy Lutomirski <luto@amacapital.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 6, 2012 at 2:49 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Thu, 29 Mar 2012 15:01:46 -0500
> Will Drewry <wad@chromium.org> wrote:
>
>> From: Andy Lutomirski <luto@amacapital.net>
>>
>> With this set, a lot of dangerous operations (chroot, unshare, etc)
>> become a lot less dangerous because there is no possibility of
>> subverting privileged binaries.
>>
>> This patch completely breaks apparmor.  Someone who understands (and
>> uses) apparmor should fix it or at least give me a hint.
>
> So [patch 2/15] fixes all this up?
>
> I guess we should join the two patches into one, to avoid a silly
> breakage window.  That means that John loses a brownie point, but we
> can mention him in the changelog, include his signed-off-by:
>
>> Signed-off-by: Andy Lutomirski <luto@amacapital.net>
>
> Several of these patches are missing your signed-off-by:.  They should
> all have your SOB, because you sent them.
> Documentation/SubmittingPatches explains this.

Oops - I'll add them!

> I'm trying to find a way to merge all this code without reviewing it ;)
> Alas, this is against my rules.  Given the length of time for which
> this patchset has been floating around, I'm a little surprised by the
> lack of acked-by's and reviewed-by's.  Have you been gathering them all
> up?  Are the networking guys all happy about this patchset?

eric.dumazet@gmail.com acked the networking ones, and I have a
smattering of others for the other patches. Given the review and
feedback, I don't have a huge number of acked/reviewed-bys. I tried
not to lose any after the first couple of revs, but I know I did some
things wrong early on.

I can prod some others who've contributed to add their tags, unless
there is a good reason for them not too.  I suspect it was just
because of partial/drive-by reviewing, but I don't know.

thanks!
will
