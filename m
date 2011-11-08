Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933277Ab1KHUSI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 15:18:08 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:28282 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933194Ab1KHUSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 15:18:06 -0500
Date: Tue, 8 Nov 2011 15:17:53 -0500
From: Chris Mason <chris.mason@oracle.com>
To: Dan Merillat <dan.merillat@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Btrfs pull request
Message-ID: <20111108201753.GA4149@shiny>
Mail-Followup-To: Chris Mason <chris.mason@oracle.com>,
	Dan Merillat <dan.merillat@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>,
	LKML <linux-kernel@vger.kernel.org>
References: <20111106183851.GA4339@shiny>
 <CAPL5yKcDKnB+BaTdARSp80pGVr_W36cy9gNz=M-S8E3NyNDTQg@mail.gmail.com>
 <20111108182728.GR4954@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111108182728.GR4954@shiny>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090203.4EB98E7B.0099,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 08, 2011 at 01:27:28PM -0500, Chris Mason wrote:
> On Tue, Nov 08, 2011 at 12:55:40PM -0500, Dan Merillat wrote:
> > On Sun, Nov 6, 2011 at 1:38 PM, Chris Mason <chris.mason@oracle.com> wrote:
> > > Hi everyone,
> > >
> > > This pull request is pretty beefy, it ended up merging a number of long
> > > running projects and cleanup queues.  I've got btrfs patches in the new
> > > kernel.org btrfs repo.  There are two different branches with the same
> > > changes.  for-linus is against 3.1 and has also been tested against
> > > Linus' tree as of yesterday.
> > 
> > [91795.123286] device label ROOT devid 1 transid 3331 /dev/sdi2
> > [91795.123538] btrfs: open_ctree failed
> > 
> > FS created on 3.1 (x64), mounted once on 3.2-rc1 (i386), got that
> > whenI tried to mount on 3.1 (x64) again.  Format change in 3.2 or
> > 32/64 bit compatibility issues?
> 
> I'm trying to reproduce right now but I did many bounces between 3.2 and
> 3.1 code before releasing.  I didn't try jumping between 32 and 64 bit.
> 
> Are there any other messages in dmesg?  Could you please see what
> btrfs-debug-tree says?

Ok, so I spun the wheel going between 32 and 64 and 3.1 and 3.2.  I'm
not having trouble with basic tests.

So, we'll have to dig in and see why the open is failing.  btrfsck or
btrfs-debug-tree will help.

-chris

