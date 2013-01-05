Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab3AECdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 21:33:09 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:55341 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755561Ab3AECdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 21:33:07 -0500
X-Sasl-enc: p3unOcTb4p/TWSU7dfaOwPybYsR6tzu+Jb/FLgzaHhyo 1357353185
Date: Fri, 4 Jan 2013 18:33:20 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bill Pemberton <wfp5p@virginia.edu>,
        Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: linux-next: manual merge of the driver-core.current tree with
 Linus tree
Message-ID: <20130105023320.GA9606@kroah.com>
References: <20130102103726.edc15af3340bb990991ed0c1@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130102103726.edc15af3340bb990991ed0c1@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 10:37:26AM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the driver-core.current tree got a conflict
> in drivers/i2c/busses/i2c-au1550.c between commit 0b255e927d47 ("i2c:
> remove __dev* attributes from subsystem") from Linus' tree and commit
> eeb30d064414 ("Drivers: i2c: remove __dev* attributes") from the
> driver-core.current tree.
> 
> I fixed it up (I used the driver-core.current version) and can carry the
> fix as necessary (no action is required).

All of these should no longer be an issue due to the driver-core.current
tree getting merged into Linus's tree.

Hopefully it should not be a merge issue for you anymore as well.

thanks,

greg k-h
