Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752016Ab2JMHve (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 03:51:34 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38625 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751404Ab2JMHvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 03:51:33 -0400
Date: Sat, 13 Oct 2012 08:51:28 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs pile 3
Message-ID: <20121013075128.GQ2616@ZenIV.linux.org.uk>
References: <20121013002003.GL2616@ZenIV.linux.org.uk>
 <5079164D.4030307@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5079164D.4030307@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 13, 2012 at 09:20:45AM +0200, Marco Stornelli wrote:
> Il 13/10/2012 02:20, Al Viro ha scritto:
> >	Stuff from Jeff Layton, mostly.  Sanitizing interplay between
> >audit and namei, removing a lot of insanity from audit_inode() mess
> >and getting things ready for his ESTALE patchset.  Please, pull from
> >the usual place -
> >git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-linus
> >
> 
> Al,
> 
> do you see any problem to apply the patch series "drop vmtruncate"?

It's somewhat pointless on its own...  If you were doing something with
the callers afterwards - sure, it would be make sense, but as it is...
