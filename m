Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757901Ab2DFTt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 15:49:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37126 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757671Ab2DFTtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 15:49:24 -0400
Date: Fri, 6 Apr 2012 12:49:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Will Drewry <wad@chromium.org>
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
Subject: Re: [PATCH v17 01/15] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent
 execve from granting privs
Message-Id: <20120406124921.5754e941.akpm@linux-foundation.org>
In-Reply-To: <1333051320-30872-2-git-send-email-wad@chromium.org>
References: <1333051320-30872-1-git-send-email-wad@chromium.org>
	<1333051320-30872-2-git-send-email-wad@chromium.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Mar 2012 15:01:46 -0500
Will Drewry <wad@chromium.org> wrote:

> From: Andy Lutomirski <luto@amacapital.net>
> 
> With this set, a lot of dangerous operations (chroot, unshare, etc)
> become a lot less dangerous because there is no possibility of
> subverting privileged binaries.
> 
> This patch completely breaks apparmor.  Someone who understands (and
> uses) apparmor should fix it or at least give me a hint.

So [patch 2/15] fixes all this up?

I guess we should join the two patches into one, to avoid a silly
breakage window.  That means that John loses a brownie point, but we
can mention him in the changelog, include his signed-off-by:

> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Several of these patches are missing your signed-off-by:.  They should
all have your SOB, because you sent them. 
Documentation/SubmittingPatches explains this.

I'm trying to find a way to merge all this code without reviewing it ;)
Alas, this is against my rules.  Given the length of time for which
this patchset has been floating around, I'm a little surprised by the
lack of acked-by's and reviewed-by's.  Have you been gathering them all
up?  Are the networking guys all happy about this patchset?


