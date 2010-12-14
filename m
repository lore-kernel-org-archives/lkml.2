Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310Ab0LNJii (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 04:38:38 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:61707 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757654Ab0LNJig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 04:38:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:date:message-id:subject:from:to:cc
         :content-type;
        b=liPgXqNB5qZCFmbI2ubD7IBtSu/4kV10vCDkhaNFXMNEtndHbt8r3ZVeoasuwV/MKK
         /zfiNhHRbE5YAmXuUWK5LYH9GxZUQkAoxOwIxbGEvHeT8x8zo7sUrzQo+J3Urrq3d40J
         OTJ1CCU3091q7/eeKEmbpJ7PxLSX7AuKIUHXc=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Tue, 14 Dec 2010 10:38:35 +0100
Message-ID: <AANLkTi=LG5Sbnu-_gHu5C0-mowBUAPWBmNHn0+e6LTyZ@mail.gmail.com>
Subject: Re: linux-next: Tree for December 14 (New tree: vfs-scale)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Nick Kossifidis <mickflemm@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Hutterer <peter.hutterer@who-t.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ QUOTE ]
Hi all,

[The mirroring on kernel.org is being slow again ...]

Changes since 20101213:

New tree: vfs-scale

The vfs-scale tree gained a conflict against the fuse tree.

The ieee1394 tree lost its build failure.

The wireless tree gained conflicts against the wireless-current tree.

The sound tree lost its conflict.

The input tree gained a conflict against Linus' tree.

The voltage tree gained a build failure so I used the version from
next-20101213.

The swiotlb-xen tree lost its build failure.

The cleancache tree gained a conflict against the vfs-scale tree.
[ /QUOTE ]

First of all congrats to all involved parties so that the work of Nick
was accepted as "vfs-scale" into linux-next!

I played yesterday with the new refreshed patchset (manually merged
and fixed) against systemd-v15 with kgdb/kdb.
Oh yes, there is a "dmesg" command :-) and with "btp $pid" I yesterday
night saw a NULL dereference in the backtrace.
Currently, I am compiling linux-next (next-20101214) and will take
some pictures with my digicam.

Some recommends (not that I want to teach you as GIT is for me new
playground and I follow mostly the commit-messages, which not means I
understand the complexity of the patchset), but ...

1. Please give commits a proper/sane "commit subject"
"Build fix" or "Fixed build failure" is not saying much.

2. Add credits for people investing time to test and report
Same commits did not have also credits for people reporting the build failures.
A reference to LKML posting would be fine in the "commit-body" (sorry
for my comparison with Email, do not know the GIT term).

This all is not to punish you, it is for following and documenting the
whole process.

Peter Hutterer has a wonderful blog article "On commit messages"
concerning this topic.
If all of us would follow them, the working-together will be more fruitful.

My 0.02EUR.

- Sedat -

[1] http://who-t.blogspot.com/2009/12/on-commit-messages.html
