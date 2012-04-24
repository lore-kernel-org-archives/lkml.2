Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab2DXRpM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:45:12 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:43347 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046Ab2DXRpL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:45:11 -0400
Date: Tue, 24 Apr 2012 18:45:02 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "Ted Ts'o" <tytso@mit.edu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Anton Blanchard <anton@au1.ibm.com>
Subject: Re: [git pull] vfs and fs fixes
Message-ID: <20120424174502.GC6871@ZenIV.linux.org.uk>
References: <20120417052511.GU6589@ZenIV.linux.org.uk>
 <1334805798.3143.25.camel@pasglop>
 <20120419145007.GD6317@thunk.org>
 <20120424174006.GA28788@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424174006.GA28788@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 10:40:06AM -0700, Greg KH wrote:
> On Thu, Apr 19, 2012 at 10:50:07AM -0400, Ted Ts'o wrote:
> > On Thu, Apr 19, 2012 at 01:23:18PM +1000, Benjamin Herrenschmidt wrote:
> > > >       ext4: fix endianness breakage in ext4_split_extent_at()
> > > 
> > > That smells like something we'd want in -stable no ?
> > 
> > Yes, commit af1584f5 is something that should definitely go into
> > -stable.
> 
> Now queued up, thanks.

Actually, the rest of commits from that pull also should go there; forgot
to add Cc: stable, my apologies...
