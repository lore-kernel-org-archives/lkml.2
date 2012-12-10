Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752242Ab2LJVbf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 16:31:35 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:33034 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751635Ab2LJVbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 16:31:34 -0500
MIME-Version: 1.0
In-Reply-To: <20121211082852.5e89e840a8a79c503dcb0763@canb.auug.org.au>
References: <1355160900.17101.229.camel@gandalf.local.home>
 <1355165264.17101.233.camel@gandalf.local.home> <20121210190247.GA32119@kroah.com>
 <1355166920.17101.239.camel@gandalf.local.home> <CA+55aFzvTrrM_t_K3W5s32p610MS0PuTrUUhFKaB5tGPmsW73g@mail.gmail.com>
 <20121211082852.5e89e840a8a79c503dcb0763@canb.auug.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 10 Dec 2012 13:31:13 -0800
X-Google-Sender-Auth: g082074akr7U87F34fpXC-uQSho
Message-ID: <CA+55aFxTgMR5e29Mf4i0=N0QgMhLLJ-OR_xBnazLzFOmE8JpGQ@mail.gmail.com>
Subject: Re: Missing tags in my local stable git repo
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 10, 2012 at 1:28 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Does that mean your tree could now be a problem, since you have recently
> added and then removed a branch (some of whose commits were not eventually
> committed to your master branch, I think)?

All of them were committed before that branch was removed, but yes, at
one point I did rebase that branch.

That said, as an alternate that should still be safe, assuming you
didn't then do any work on top of that rebased branch (ie your repo
doesn't have any references to any of those objects).

                   Linus
