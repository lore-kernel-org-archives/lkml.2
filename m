Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab1GNRum (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jul 2011 13:50:42 -0400
Received: from iabervon.org ([66.92.72.58]:55346 "EHLO iabervon.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932200Ab1GNRul (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jul 2011 13:50:41 -0400
Date: Thu, 14 Jul 2011 13:43:24 -0400 (EDT)
From: Daniel Barkalow <barkalow@iabervon.org>
To: Seth Forshee <seth.forshee@canonical.com>
cc: Christoph Hellwig <hch@tuxera.com>, linux-kernel@vger.kernel.org
Subject: Re: Problems with hfsplus on ipods in 2.6.38+
In-Reply-To: <20110714135302.GA28501@thinkpad-t410>
Message-ID: <alpine.LNX.2.00.1107141330370.2056@iabervon.org>
References: <alpine.LNX.2.00.1107131942190.2056@iabervon.org> <20110714135302.GA28501@thinkpad-t410>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jul 2011, Seth Forshee wrote:

> On Wed, Jul 13, 2011 at 10:10:13PM -0400, Daniel Barkalow wrote:
> > I've got an ipod which doesn't work with 2.6.38 or later, unless I revert:
> > 
> > 358f26d52680cb150907302d4334359de7dd2d59
> > 52399b171dfaea02b6944cd6feba49b624147126
> > 
> > In the failing case, I get:
> > 
> >  sd 2:0:0:0: [sdb] Bad block number requested
> >  hfs: unable to find HFS+ superblock
> > 
> > in dmesg when I try to mount it.
> > 
> > Before 2.6.38, or with those commits reverted, it mounts fine and works so 
> > far as I can tell. (There's an Ubuntu bug report: 
> > https://bugs.launchpad.net/ubuntu/+source/util-linux/+bug/734883, which 
> > reports other people having similar results). I can test patches and 
> > collect information that might be helpful, if you have any ideas.
> 
> This has had some discussion on lkml previously [1]. I've been trying to
> work on a fix, but the current iteration has problems, and I haven't
> been able to get testers to provide the logs I've requested to help me
> see what's going wrong. If you'd like to help by providing logs from the
> most recent test build on the bug you linked to (or using the patches
> from that build) that would be great. I unfortunately don't have any
> large-sector devices to test with and cannot reproduce the problems on
> 512-byte sector devices.

Sure, I'll try the comment #36 patch set this evening and see what it says.

	-Daniel
*This .sig left intentionally blank*
