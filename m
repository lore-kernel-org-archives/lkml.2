Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760962Ab2D0RzW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:55:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760242Ab2D0RzU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:55:20 -0400
Date: Fri, 27 Apr 2012 19:54:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matt Fleming <matt@console-pimps.org>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120427175434.GA31524@redhat.com>
References: <CA+55aFxia+u3VAf0qN-2wv7DyAQZK-Z8=n=cqUvo--+C905aFg@mail.gmail.com> <20120420160848.GG6871@ZenIV.linux.org.uk> <20120420164239.GH6871@ZenIV.linux.org.uk> <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com> <20120420180748.GI6871@ZenIV.linux.org.uk> <20120423180150.GA6871@ZenIV.linux.org.uk> <20120424072617.GB6871@ZenIV.linux.org.uk> <20120426183742.GA324@redhat.com> <20120426231942.GJ6871@ZenIV.linux.org.uk> <20120427172444.GA30267@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427172444.GA30267@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27, Oleg Nesterov wrote:
>
> Not only sigreturn. Just look at sigprocmask(SIG_SETMASK) callers, almost
> all should be converted to use set_current_blocked(). For example, pselect.

which btw doesn't need sigsaved.

> The last thing. Matt, could you please look at
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal.git ? It seems to me
> you already sent some of these changes (use set_current_blocked/block_sigmask).
> Perhaps there are alreay in -mm or linux-next?

Forgot to add Matt, sorry for noise...

Oleg.

