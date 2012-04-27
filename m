Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761346Ab2D0TnC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 15:43:02 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:46146 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760737Ab2D0TnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 15:43:00 -0400
Date: Fri, 27 Apr 2012 20:42:58 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120427194258.GN6871@ZenIV.linux.org.uk>
References: <20120420160848.GG6871@ZenIV.linux.org.uk>
 <20120420164239.GH6871@ZenIV.linux.org.uk>
 <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com>
 <20120420180748.GI6871@ZenIV.linux.org.uk>
 <20120423180150.GA6871@ZenIV.linux.org.uk>
 <20120424072617.GB6871@ZenIV.linux.org.uk>
 <20120426183742.GA324@redhat.com>
 <20120426231942.GJ6871@ZenIV.linux.org.uk>
 <20120427172444.GA30267@redhat.com>
 <20120427184528.GL6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427184528.GL6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 07:45:29PM +0100, Al Viro wrote:

> > The last thing. Matt, could you please look at
> > git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal.git ? It seems to me
> > you already sent some of these changes (use set_current_blocked/block_sigmask).
> > Perhaps there are alreay in -mm or linux-next?

BTW, I'll gladly pick Matt's patches in front of that queue (and drop my
duplicates), but I doubt that signal.git is suitable for -next right now.
After some review from linux-arch folks - maybe, but right now it's too
dangerous and untested.
