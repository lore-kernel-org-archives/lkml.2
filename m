Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751095Ab2K2FPY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 00:15:24 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:53308 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750721Ab2K2FPX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 00:15:23 -0500
X-Sasl-enc: 8zwf3z96ERRmS7xN19TIrCrjLhMdMessz72Uypc5fwn3 1354166122
Date: Wed, 28 Nov 2012 21:17:00 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Hurley <peter@hurleysoftware.com>
Subject: Re: linux-next: manual merge of the staging tree with the tty tree
Message-ID: <20121129051700.GB4375@kroah.com>
References: <20121129154739.241d7a45c8bab79b3aeb9fe6@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129154739.241d7a45c8bab79b3aeb9fe6@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 03:47:39PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the staging tree got a conflicts in
> drivers/staging/fwserial/fwserial.c, drivers/staging/Kconfig and
> drivers/staging/Kconfig between commit 7355ba3445f2 ("staging: fwserial:
> Add TTY-over-Firewire serial driver") from the tty tree and commit
> e5711071ad94 ("staging: fwserial: Add TTY-over-Firewire serial driver")
> from the staging tree.
> 
> I am not sure why this patch exists in both trees :-(

I needed to do that to handle the tty driver changes that were required
for it due to the tty layer changes.

> I fixed it up (they are the same but the trees contain more commits
> affecting these files) and can carry the fix as necessary (no action is
> required).

The tty tree will end up having the "correct" one here, thanks for
resolving this in your tree.

greg k-h
