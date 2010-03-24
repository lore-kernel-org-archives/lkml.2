Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754468Ab0CXCia (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 22:38:30 -0400
Received: from cantor.suse.de ([195.135.220.2]:60654 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754313Ab0CXCi0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 22:38:26 -0400
Date: Tue, 23 Mar 2010 19:28:45 -0700
From: Greg KH <gregkh@suse.de>
To: pavan_savoy@ti.com
Cc: alan@lxorguk.ukuu.org.uk, linux-kernel@vger.kernel.org,
       pavan_savoy@yahoo.co.in
Subject: Re: [PATCH 2/7] drivers:staging: Kconfig, Makefile for TI's ST
	ldisc
Message-ID: <20100324022845.GB4359@suse.de>
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
>  drivers/staging/ti-st/Kconfig  |   24 ++++++++++++++++++++++++
>  drivers/staging/ti-st/Makefile |    7 +++++++

Again, you just broke the build.

Please fix the ordering of your patches.

thanks,

greg k-h
