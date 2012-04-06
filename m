Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412Ab2DFU22 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 16:28:28 -0400
Received: from tex.lwn.net ([70.33.254.29]:50909 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755062Ab2DFU21 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 16:28:27 -0400
Date: Fri, 6 Apr 2012 14:28:24 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Andrew Lutomirski <luto@mit.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, Will Drewry <wad@chromium.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org,
        scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com,
        keescook@chromium.org, jmorris@namei.org,
        Andy Lutomirski <luto@amacapital.net>, linux-man@vger.kernel.org
Subject: Re: [PATCH v17 01/15] Add PR_{GET,SET}_NO_NEW_PRIVS to prevent
 execve from granting privs
Message-ID: <20120406142824.61d8ca3b@lwn.net>
In-Reply-To: <CAObL_7EYb62o=a0ekzcDx=0TuN55A7aTYhLJbMNu2r8F0V77EA@mail.gmail.com>
References: <1333051320-30872-1-git-send-email-wad@chromium.org>
	<1333051320-30872-2-git-send-email-wad@chromium.org>
	<20120406125517.77133b4e.akpm@linux-foundation.org>
	<CAObL_7EYb62o=a0ekzcDx=0TuN55A7aTYhLJbMNu2r8F0V77EA@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Apr 2012 13:01:17 -0700
Andrew Lutomirski <luto@mit.edu> wrote:

> This has been bugging me for awhile.  Is there any interest in moving
> the manpages into the kernel source tree?  Then there could be a
> general requirement that new APIs get documented when they're written.

Man page (or other documentation) requirements for patch acceptance are a
regular kernel summit feature.  People seem to think it's a good idea, but
actual enforcement of such requirements always seems to be lacking.  Lots
of people have kind of given up trying.  I don't really see that adding
the man pages to the tree would help, but I could be wrong...

jon
