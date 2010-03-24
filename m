Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754271Ab0CXCiW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 22:38:22 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55396 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751968Ab0CXCiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 22:38:21 -0400
Date: Tue, 23 Mar 2010 19:28:03 -0700
From: Greg KH <gregkh@suse.de>
To: pavan_savoy@ti.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       pavan_savoy@yahoo.co.in
Subject: Re: [PATCH 1/7] serial: TTY: new ldisc for TI BT/FM/GPS chips
Message-ID: <20100324022803.GA4359@suse.de>
References: <1269376875-25940-1-git-send-email-pavan_savoy@ti.com> <1269376875-25940-2-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269376875-25940-2-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 03:41:09PM -0500, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> A new N_TI_WL line discipline added for TI BT/FM/GPS
> combo chips which make use of same TTY to communicate
> with chip. This is to be made use of individual protocol
> BT/FM/GPS drivers.
> 
> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> ---
>  include/linux/tty.h |    3 ++-

Staging code needs to be completly self-contained in the drivers/staging
directory.  Is there any way to do this without touching this file?

thanks,

greg k-h
