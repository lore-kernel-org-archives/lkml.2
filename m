Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2CEQxp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:53:45 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:50489 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756952Ab2CEQxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:53:43 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.242.135 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Mon, 5 Mar 2012 08:42:16 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shengzhou Liu <Shengzhou.Liu@freescale.com>
Subject: Re: linux-next: manual merge of the usb tree with the usb.current
 tree
Message-ID: <20120305164216.GD2459@kroah.com>
References: <20120305170004.9c81f2d148cc179f42a39ade@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120305170004.9c81f2d148cc179f42a39ade@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 05, 2012 at 05:00:04PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> drivers/usb/host/ehci-fsl.h between commit 71919403dc86 ("Revert
> "powerpc/usb: fix issue of CPU halt when missing USB PHY clock"") from
> the usb.current tree and commit 28c56ea14314 ("powerpc/usb: fix bug of
> kernel hang when initializing usb") from the usb tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Looks good, thanks for this, I'll handle the merge when Linus takes my
usb-linus tree in a few days.

greg k-h
