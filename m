Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935445Ab2JXS2X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:28:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38951 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935245Ab2JXS2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:28:20 -0400
Date: Wed, 24 Oct 2012 11:28:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Cyrill Gorcunov <gorcunov@openvz.org>
Cc: linux-kernel@vger.kernel.org, alan@lxorguk.ukuu.org.uk, hpa@zytor.com,
        xemul@parallels.com, jslaby@suse.cz
Subject: Re: [patch 2/3] tty, ioctls -- Add new ioctl definitions for tty
 flags fetching
Message-ID: <20121024182816.GA2642@kroah.com>
References: <20120927211032.576475929@openvz.org>
 <20120927211121.732319261@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120927211121.732319261@openvz.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 28, 2012 at 01:10:34AM +0400, Cyrill Gorcunov wrote:
> This patch defines new ioctl codes TIOCGPKT, TIOCGPTLCK,
> TIOCGEXCL for fetching pty's packet mode and locking state,
> and exclusive mode of tty.
> 
> [ No real handlers for the codes though, this will be
>   addressed in another patch for easier review and
>   bisectability ]
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> CC: Alan Cox <alan@lxorguk.ukuu.org.uk>
> CC: "H. Peter Anvin" <hpa@zytor.com>
> CC: Pavel Emelyanov <xemul@parallels.com>
> CC: Jiri Slaby <jslaby@suse.cz>
> ---
>  arch/alpha/include/asm/ioctls.h   |    3 +++
>  arch/mips/include/asm/ioctls.h    |    3 +++
>  arch/parisc/include/asm/ioctls.h  |    3 +++
>  arch/powerpc/include/asm/ioctls.h |    3 +++
>  arch/sh/include/asm/ioctls.h      |    3 +++
>  arch/sparc/include/asm/ioctls.h   |    3 +++
>  arch/xtensa/include/asm/ioctls.h  |    3 +++
>  fs/compat_ioctl.c                 |    3 +++
>  include/asm-generic/ioctls.h      |    3 +++
>  9 files changed, 27 insertions(+)

Most of these files are no longer in the tree.  Can you redo this
against the latest linux-next release and resend the whole series?

thanks,

greg k-h
