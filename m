Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751622Ab0LKVEa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Dec 2010 16:04:30 -0500
Received: from mail.fuw.edu.pl ([193.0.80.14]:48281 "EHLO mail.fuw.edu.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345Ab0LKVEa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Dec 2010 16:04:30 -0500
X-Greylist: delayed 814 seconds by postgrey-1.27 at vger.kernel.org; Sat, 11 Dec 2010 16:04:29 EST
From: "R. J. Wysocki" <Rafal.Wysocki@fuw.edu.pl>
To: Bojan Smojver <bojan@rexursive.com>
Subject: Re: [linux-pm] [PATCH] PM / Hibernate: Restore old swap signature to avoid user space breakage
Date: Sat, 11 Dec 2010 21:49:27 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5+; KDE/4.4.4; x86_64; ; )
Cc: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>,
        Karel Zak <kzak@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        "Dr. David Alan Gilbert" <linux@treblig.org>
References: <201012052324.30231.rjw@sisk.pl> <201012112136.23543.rjw@sisk.pl> <1292100440.1630.11.camel@shrek.rexursive.com>
In-Reply-To: <1292100440.1630.11.camel@shrek.rexursive.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201012112149.27399.rwys@fuw.edu.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, December 11, 2010, Bojan Smojver wrote:
> On Sat, 2010-12-11 at 21:36 +0100, Rafael J. Wysocki wrote:
> 
> > Because that wouldn't fix the user space that _already_ is out there.
> 
> Of course. I'm sure there are other things in various new kernel that
> older user space isn't aware of. It just depends on how far back you
> wish to go.
> 
> > That doesn't matter.  The rule is we don't break user space, even if it does
> > unreasonable things.
> 
> But it won't really be broken. I actually tested compression patches on
> F-14. All you need to do is pass resume argument to grub for 2.6.37
> kernel you installed by hand (and at present, you can only do this by
> hand). If Fedora folks decide to upgrade the kernel to 2.6.37 for F-14
> (they already have for F-15, so they must be aware of the issue), I'm
> sure they'll fix util-linux-ng, dracut and whatever else is required for
> this to work.

Then we can change the signature, no earlier.

> PS. Koji build of the kernel for F-15, based in 2.6.37-rc5:
> 
> http://koji.fedoraproject.org/koji/buildinfo?buildID=208625

Thanks,
Rafael
