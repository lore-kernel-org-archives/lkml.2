Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754654Ab0LGEnF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 23:43:05 -0500
Received: from kroah.org ([198.145.64.141]:41164 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753038Ab0LGEnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 23:43:02 -0500
Date: Mon, 6 Dec 2010 20:43:10 -0800
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: Re: linux-next: manual merge of the usb tree with the sh tree
Message-ID: <20101207044310.GA29457@kroah.com>
References: <20101206124723.72a8cd7f.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101206124723.72a8cd7f.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 06, 2010 at 12:47:23PM +1100, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> arch/sh/Kconfig between commit f020c92de48246510623162fb22d60d91810cc56
> ("sh: Enable optional gpiolib for all CPUs with pinmux tables") from the
> sh tree and commit e3e9887ee9de36d8e2bef972ad74a42abd7a44c4 ("sh: Convert
> to USB_ARCH_HAS_OHCI/EHCI selects") from the usb tree.
> 
> Just context changes.  I fixed ti up (see below) and can carry the fix as
> necessary.

Looks good, thanks for carrying this.

greg k-h
