Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755272Ab0ENU1H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 16:27:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20039 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab0ENU1D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 16:27:03 -0400
Subject: Re: [PATCH] anon_inode: set S_IFREG on the anon_inode
From: Eric Paris <eparis@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, npiggin@suse.de
In-Reply-To: <20100514202329.GX30031@ZenIV.linux.org.uk>
References: <20100514200555.17387.92658.stgit@paris.rdu.redhat.com>
	 <20100514202329.GX30031@ZenIV.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 May 2010 16:26:23 -0400
Message-ID: <1273868783.2826.31.camel@localhost>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-14 at 21:23 +0100, Al Viro wrote:
> On Fri, May 14, 2010 at 04:05:59PM -0400, Eric Paris wrote:
> > anon_inode_mkinode() sets inode->i_mode = S_IRUSR | S_IWUSR;  This means
> > that (inode->i_mode & S_IFMT) == 0.  This trips up some SELinux code that
> > needs to determine if a given inode is a regular file, a directory, etc.
> > The easiest solution is to just make sure that the anon_inode also sets
> > S_IFREG.
> 
> How urgent that one is?  It is obvious enough, so I could include it into
> the pull request for -final, but...

printk spam.  No hurry.  Probably should have put that in the commit
message.

-Eric

