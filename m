Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab2DXR7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:59:18 -0400
Received: from mail-pz0-f51.google.com ([209.85.210.51]:44849 "EHLO
	mail-pz0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757050Ab2DXR7Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:59:16 -0400
Date: Tue, 24 Apr 2012 10:59:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Ted Ts'o" <tytso@mit.edu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Anton Blanchard <anton@au1.ibm.com>
Subject: Re: [git pull] vfs and fs fixes
Message-ID: <20120424175911.GA22958@kroah.com>
References: <20120417052511.GU6589@ZenIV.linux.org.uk>
 <1334805798.3143.25.camel@pasglop>
 <20120419145007.GD6317@thunk.org>
 <20120424174006.GA28788@kroah.com>
 <20120424174502.GC6871@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120424174502.GC6871@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 06:45:02PM +0100, Al Viro wrote:
> On Tue, Apr 24, 2012 at 10:40:06AM -0700, Greg KH wrote:
> > On Thu, Apr 19, 2012 at 10:50:07AM -0400, Ted Ts'o wrote:
> > > On Thu, Apr 19, 2012 at 01:23:18PM +1000, Benjamin Herrenschmidt wrote:
> > > > >       ext4: fix endianness breakage in ext4_split_extent_at()
> > > > 
> > > > That smells like something we'd want in -stable no ?
> > > 
> > > Yes, commit af1584f5 is something that should definitely go into
> > > -stable.
> > 
> > Now queued up, thanks.
> 
> Actually, the rest of commits from that pull also should go there; forgot
> to add Cc: stable, my apologies...

So that would be commits
96f6f98501196d46ce52c2697dd758d9300c63f5..e847469bf77a1d339274074ed068d461f0c872bc
inclusive?

Or a different range?

thanks,

greg k-h
