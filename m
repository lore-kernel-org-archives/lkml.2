Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab1LJDVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 22:21:36 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53063 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751728Ab1LJDVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 22:21:34 -0500
X-Sasl-enc: D8zdy8gCh2D02QPl56dNoVwP5bglKvbEMKShU2x8ln18 1323487294
Date: Fri, 9 Dec 2011 19:14:54 -0800
From: Greg KH <greg@kroah.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: gregkh@suse.de, alan@linux.intel.com, galak@kernel.crashing.org,
        linux-serial@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] tty-next: Fix Fsl 8250 BRK bug
Message-ID: <20111210031454.GA8265@kroah.com>
References: <20111207033957.GB20556@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111207033957.GB20556@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 06, 2011 at 10:39:57PM -0500, Paul Gortmaker wrote:
> Hi Greg,
> 
> This is the Freescale hardware bug fix which turned into a
> six-pack of 8250 updates.  This is exactly what was posted
> in the v2 review, with just Alan's ack added[1].  Since nobody
> else has had any follow-on comments since then, I'm assuming
> that it is now good to go.
> 
> [1] https://lkml.org/lkml/2011/12/5/156
> 
> Thanks,
> Paul.
> ---
> 
> Please pull for tty-next to get:
> 
> The following changes since commit 5611cc4572e889b62a7b4c72a413536bf6a9c416:
> 
>   Linux 3.2-rc4 (2011-12-01 14:56:01 -0800)
> 
> are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulg/linux fsl-uart-fix

I took the "raw" patches from the emails, so you can delete this branch
now.

thanks,

greg k-h
