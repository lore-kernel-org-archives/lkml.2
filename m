Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755028Ab3ADAIu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 19:08:50 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:58905 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753811Ab3ADAIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 19:08:47 -0500
X-Sasl-enc: oOLp+Bv0k4q0x3TnN02OS3FfnNO9WfHjXvrH14YoMaZ4 1357258126
Date: Thu, 3 Jan 2013 16:08:45 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: Re: linux-next: bad merge in driver-core.current tree
Message-ID: <20130104000845.GA27734@kroah.com>
References: <20130104100540.3671b46eb7de73374db7f786@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130104100540.3671b46eb7de73374db7f786@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 04, 2013 at 10:05:40AM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Happy New year!  ;-)
> 
> Today you added a merge of v3.8-rc2 to the driver-core.current tree.  It
> added the file drivers/i2c/Module.symvers which is a generated file :-(

Yeah, I realized that after sending it to Linus :(

> Please consider rebuilding your tree to get rid of it.

It's now rebuilt.

> Also, you might consider removing all the patches that remove the
> __dev* stuff as they are really not urgent, cause many conflicts (and
> will continue to do so) and most (if not all) are not acked by the
> maintainers of the subsystems that they should be applied to (did you
> send your revised versions of Bill's patches to those maintainers?).
> You might consider sending separate patches to fix the coding style
> problems after Bill's patches rather than modifying Bill's patches as
> some of Bill's patches are turning up in other subsystems (as happened
> with i2c).

I'd really like to just be rid of these __dev* markings now, instead of
dragging it out over two kernel releases.  The patches are now all fixed
up properly, and I'll be sending a new merge request to Linus right
after this after the git tree is mirrored properly.

thanks,

greg k-h
