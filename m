Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752507Ab0LKUrY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 15:47:24 -0500
Received: from beauty.rexursive.com ([150.101.121.179]:52595 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752234Ab0LKUrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 15:47:23 -0500
Subject: Re: [linux-pm] [PATCH] PM / Hibernate: Restore old swap signature
 to avoid user space breakage
From: Bojan Smojver <bojan@rexursive.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Karel Zak <kzak@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <linux@treblig.org>
In-Reply-To: <201012112136.23543.rjw@sisk.pl>
References: <201012052324.30231.rjw@sisk.pl>
	 <201012112058.09689.rjw@sisk.pl>
	 <1292099420.1630.3.camel@shrek.rexursive.com>
	 <201012112136.23543.rjw@sisk.pl>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Dec 2010 07:47:20 +1100
Message-ID: <1292100440.1630.11.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-12-11 at 21:36 +0100, Rafael J. Wysocki wrote:

> Because that wouldn't fix the user space that _already_ is out there.

Of course. I'm sure there are other things in various new kernel that
older user space isn't aware of. It just depends on how far back you
wish to go.

> That doesn't matter.  The rule is we don't break user space, even if it does
> unreasonable things.

But it won't really be broken. I actually tested compression patches on
F-14. All you need to do is pass resume argument to grub for 2.6.37
kernel you installed by hand (and at present, you can only do this by
hand). If Fedora folks decide to upgrade the kernel to 2.6.37 for F-14
(they already have for F-15, so they must be aware of the issue), I'm
sure they'll fix util-linux-ng, dracut and whatever else is required for
this to work.

PS. Koji build of the kernel for F-15, based in 2.6.37-rc5:

http://koji.fedoraproject.org/koji/buildinfo?buildID=208625

-- 
Bojan

