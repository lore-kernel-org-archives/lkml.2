Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab2DVUpz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 16:45:55 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:58119 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752205Ab2DVUpy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 16:45:54 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Per Olofsson <pelle@debian.org>
Subject: Re: [PATCH v11]: Hibernation: fix the number of pages used for hibernate/thaw buffering
Date: Sun, 22 Apr 2012 22:50:31 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc3+; KDE/4.6.0; x86_64; ; )
Cc: Bojan Smojver <bojan@rexursive.com>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>
References: <1334267969.2573.14.camel@shrek.rexursive.com> <201204222229.47160.rjw@sisk.pl> <4F946B86.4000509@debian.org>
In-Reply-To: <4F946B86.4000509@debian.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204222250.31350.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, April 22, 2012, Per Olofsson wrote:
> 2012-04-22 22:29, Rafael J. Wysocki skrev:
> > Well, it was late for the 3.4 merge window and it wasn't clear whether or
> > not the patch was a regression fix at that time.  It is not very
> > straightforward and in my opinion it should be tested a bit wider before it
> > goes into -stable.
> 
> Hopefully it will soon get applied in Debian unstable and then get much
> more testing.
> 
> It is also possible to create a much smaller patch which only subtracts
> the high pages and nothing else.

I've just pushed it to my linux-next branch, so it should appear in linux-next
tomorrow.

Still, we are a few weeks from the 3.5 merge window, so it's not that much time
to wait anyway.

Thanks,
Rafael
