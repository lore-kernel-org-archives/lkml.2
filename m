Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756985Ab2DXRkL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 13:40:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48207 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755840Ab2DXRkK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 13:40:10 -0400
Date: Tue, 24 Apr 2012 10:40:06 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: "Ted Ts'o" <tytso@mit.edu>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Anton Blanchard <anton@au1.ibm.com>
Subject: Re: [git pull] vfs and fs fixes
Message-ID: <20120424174006.GA28788@kroah.com>
References: <20120417052511.GU6589@ZenIV.linux.org.uk>
 <1334805798.3143.25.camel@pasglop>
 <20120419145007.GD6317@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120419145007.GD6317@thunk.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 10:50:07AM -0400, Ted Ts'o wrote:
> On Thu, Apr 19, 2012 at 01:23:18PM +1000, Benjamin Herrenschmidt wrote:
> > >       ext4: fix endianness breakage in ext4_split_extent_at()
> > 
> > That smells like something we'd want in -stable no ?
> 
> Yes, commit af1584f5 is something that should definitely go into
> -stable.

Now queued up, thanks.

greg k-h
