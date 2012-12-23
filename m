Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752642Ab2LWX1B (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 18:27:01 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:54293 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752157Ab2LWX05 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 18:26:57 -0500
X-Sasl-enc: iCaWzUCJv9ZJ2qfIochFYeEY8gB7Szud61FGmoOtPbfe 1356305216
Date: Sun, 23 Dec 2012 15:30:10 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Jean Delvare <khali@linux-fr.org>
Subject: Re: linux-next: manual merge of the driver-core.current tree with
 Linus' tree
Message-ID: <20121223233010.GA23879@kroah.com>
References: <20121224095200.a94a61d18925f30909964dfb@canb.auug.org.au>
 <20121224095614.3d1fc65e9ade946cc6a8a2e1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121224095614.3d1fc65e9ade946cc6a8a2e1@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 24, 2012 at 09:56:14AM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> On Mon, 24 Dec 2012 09:52:00 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next merge of the driver-core.current tree got conflicts
> > in 21 files in drivers/i2c between commit 0b255e927d47 ("i2c: remove
> > __dev* attributes from subsystem") from Linus' tree and commit
> > eeb30d064414 ("Drivers: i2c: remove __dev* attributes") from the
> > driver-core.current tree.
> > 
> > I fixed it up (taking a mixture of both commits) and can carry the fix as
> > necessary (no action is required).
> 
> BTW, Greg, the patch in your tree to drivers/i2c/busses/i2c-au1550.c is
> incorrect and would not build.

Ugh, that's a horrible merge error on my part, thanks for pointing it
out.  My 'make allmodconfig' doesn't happen to build that module.

And sorry about the merge issues, I wasn't aware that Wolfram was going
to be sending these to Linus after 3.8-rc1 was out, sorry about that.
The merge issues are due to me trying to get the coding style correct,
which Bill's sed script didn't always do.

thanks,

greg k-h
