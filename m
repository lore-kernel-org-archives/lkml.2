Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755182Ab1GQJSh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 05:18:37 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:46670 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754901Ab1GQJSe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 05:18:34 -0400
X-Sasl-enc: S+bbIswfMEGaW8KJL+X8UGReBVd6YUiKxNZOUPiJmdF6 1310894312
Date: Sun, 17 Jul 2011 11:16:10 +0200
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vitaliy Ivanov <vitalivanov@gmail.com>, Jiri Kosina <jkosina@suse.cz>
Subject: Re: linux-next: manual merge of the staging tree with the trivial
 tree
Message-ID: <20110717091610.GE25824@kroah.com>
References: <20110716225643.426f99dafa7fcebab4cd9be8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110716225643.426f99dafa7fcebab4cd9be8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 16, 2011 at 10:56:43PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflict in
> drivers/staging/westbridge/astoria/arch/arm/plat-omap/include/mach/westbridge/westbridge-omap3-pnand-hal/cyashalomap_kernel.h
> drivers/staging/westbridge/astoria/gadget/cyasgadget.h between commit
> e44ba033c565 ("treewide: remove duplicate includes") from the trivial
> tree and commit 78f23926dff9 ("Staging: delete westbridge code") from the
> staging tree.
> 
> The latter removes the files, so I did that.

Thanks, that is correct.
