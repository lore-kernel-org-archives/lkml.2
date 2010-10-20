Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753204Ab0JTVSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 17:18:18 -0400
Received: from cantor.suse.de ([195.135.220.2]:45319 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751490Ab0JTVSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 17:18:17 -0400
Date: Wed, 20 Oct 2010 14:16:43 -0700
From: Greg KH <gregkh@suse.de>
To: Alexey Charkov <alchark@gmail.com>
Cc: vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] serial: Add support for UART on VIA VT8500 and
 compatibles
Message-ID: <20101020211643.GA10006@suse.de>
References: <1287608139-21354-1-git-send-email-alchark@gmail.com>
 <1287608139-21354-2-git-send-email-alchark@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1287608139-21354-2-git-send-email-alchark@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 12:55:34AM +0400, Alexey Charkov wrote:
> This adds a driver for the serial ports found in VIA and WonderMedia
> Systems-on-Chip. Interrupt-driven FIFO operation is implemented.
> The hardware also supports pure register-based operation (which is
> slower) and DMA-based FIFO operation. As the FIFOs are only 16 bytes
> long, DMA operation is probably not worth the hassle.
> 
> Signed-off-by: Alexey Charkov <alchark@gmail.com>
> ---
> 
> Please review and state whether this could be acceptable for a merge
> to mainline in the coming 2.6.37 window.

.37?  Aren't you cutting it a bit close here?  My trees unofficially
closed a few days or so ago for new stuff to go to .37, what kept this
from being sent previously?

> If possible, I would deeply appreciate a merge to a relevant git tree
> for integration prior to asking Linus to pull the changes. I could
> rebase the code if needed, currently this is against Linus' master
> branch.
> 
> This patch relies on the basic architecture support for VT8500/WM8505
> to be in place, as introduced by PATCH 1/6 in this series.

So it will just fail to build without that patch?

thanks,

greg k-h
