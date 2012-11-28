Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756230Ab2K1WQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 17:16:16 -0500
Received: from mail.kernel.org ([198.145.19.201]:39187 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755663Ab2K1WQP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 17:16:15 -0500
Date: Wed, 28 Nov 2012 14:16:13 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Bill Pemberton <wfp5p@virginia.edu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: HOTPLUG replated patches
Message-ID: <20121128221613.GA13534@kroah.com>
References: <20121129090412.4fc1a6e5a41f9bc24b827c7c@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129090412.4fc1a6e5a41f9bc24b827c7c@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 09:04:12AM +1100, Stephen Rothwell wrote:
> Hi all,
> 
> I haven't been closely following things, but is there any reason that a
> large number of these CONFIG_HOTPLUG and __dev* patches are being merged
> via the driver-core tree rather than through the relevant maintainers
> trees? They aren't particularly urgent as far as I can see.  And they
> already have, and probably will, cause unnecessary conflicts between
> trees.

I merged the ones that were acked by the subsystem maintainer through my
driver-core tree.  Others are coming in through the subsystem
maintainer's trees, as they have applied them there.

So it's a mix, depending on the subsystem maintainer's wishes.

And yes, it's going to be a bunch of trivial merge issues, sorry about
that, I don't know of any other way at the moment to deal with that.

thanks,

greg k-h
