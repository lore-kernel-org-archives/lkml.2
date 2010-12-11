Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab0LKUhE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 15:37:04 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:46327 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014Ab0LKUhB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 15:37:01 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [linux-pm] [PATCH] PM / Hibernate: Restore old swap signature to avoid user space breakage
Date: Sat, 11 Dec 2010 21:36:23 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Karel Zak <kzak@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <linux@treblig.org>
References: <201012052324.30231.rjw@sisk.pl> <201012112058.09689.rjw@sisk.pl> <1292099420.1630.3.camel@shrek.rexursive.com>
In-Reply-To: <1292099420.1630.3.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012112136.23543.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 11, 2010, Bojan Smojver wrote:
> On Sat, 2010-12-11 at 20:58 +0100, Rafael J. Wysocki wrote:
> > I'm afraid I'll have to push this patch to Linus.  Turns out that
> > Fedora 14 doesn't pass the resume= argument to the kernel and tries to
> > trigger the resume from initramfs.  Since the signature changed, it
> > can't find the image and the resume fails, even if both the resume and
> > image kernels are the same. 
> 
> Why don't you just file a Fedora bug asking for the library to be
> upgraded or patched?

Because that wouldn't fix the user space that _already_ is out there.

> PS. Karel, who also replied to this thread, has a Red Hat address and he
> seems to be the maintainer of util-linux-ng package. He should be able
> to fix this.

That doesn't matter.  The rule is we don't break user space, even if it does
unreasonable things.

Thanks,
Rafael
