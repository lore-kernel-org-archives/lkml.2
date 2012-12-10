Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751745Ab2LJVJR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:09:17 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33687 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab2LJVJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:09:15 -0500
MIME-Version: 1.0
In-Reply-To: <1355172274.17101.250.camel@gandalf.local.home>
References: <1355160900.17101.229.camel@gandalf.local.home>
 <1355165264.17101.233.camel@gandalf.local.home> <20121210190247.GA32119@kroah.com>
 <1355166920.17101.239.camel@gandalf.local.home> <CA+55aFzvTrrM_t_K3W5s32p610MS0PuTrUUhFKaB5tGPmsW73g@mail.gmail.com>
 <1355172274.17101.250.camel@gandalf.local.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 10 Dec 2012 13:08:54 -0800
X-Google-Sender-Auth: 3f8Hn7Kk-uGszqRsISemK9eW-tM
Message-ID: <CA+55aFx=x9OzUvD+x+tUBxNN8EWRHEo7UuMx8OYBdyG3W+AcUw@mail.gmail.com>
Subject: Re: Missing tags in my local stable git repo
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 12:44 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> OK, this may be my issue, as my stable.git has my copy of your tree as
> an alternate. Maybe I can merge the two trees.

That should work. Of course, it would depend on there not being any
clashes in the tag namespace, but we don't do that anyway (since it
would confuse everybody), so it should all be ok.

I would almost suggest you make both my base tree and the stable tree
be remotes, instead of necessarily mirroring my tree and then putting
the stable tree on top of that. I think it's confusing to have a
mirror but than in that same tree have an extra (non-mirror) remote,
it sounds more logical to me to have two separate remotes.

But yeah, you should always just be able to recreate things since
whatever you do your alternates will never have any extra work in
them, so you could just continue with your existing setup even though
it sounds a bit iffy.

                Linus
