Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab0CXCio (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 22:38:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55400 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754478Ab0CXCie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 22:38:34 -0400
Date: Tue, 23 Mar 2010 19:30:13 -0700
From: Greg KH <gregkh@suse.de>
To: pavan_savoy@ti.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       pavan_savoy@yahoo.co.in
Subject: Re: [PATCH 2/7] drivers:staging: Kconfig, Makefile for TI's ST
	ldisc
Message-ID: <20100324023013.GD4359@suse.de>
References: <1269376875-25940-1-git-send-email-pavan_savoy@ti.com> <1269376875-25940-2-git-send-email-pavan_savoy@ti.com> <1269376875-25940-3-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269376875-25940-3-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 23, 2010 at 03:41:10PM -0500, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> This change adds the Kconfig and Make file for TI's
> ST line discipline driver and the BlueZ driver for BT
> core of the TI BT/FM/GPS combo chip.
> 
> Signed-off-by: Pavan Savoy <pavan_savoy@ti.com>
> ---
>  drivers/staging/Kconfig        |    2 ++
>  drivers/staging/Makefile       |    1 +

To add a new staging driver, I need a TODO file that lists what needs to
be done to the code in order to get it merged into the main portion of
the kernel, and who is responsible for it.  Look at the other
drivers/staging/*/TODO files for examples of what to do.

thanks,

greg k-h
