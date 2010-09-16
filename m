Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756705Ab0IPWtf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 18:49:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34393 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755712Ab0IPWtd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 18:49:33 -0400
Date: Thu, 16 Sep 2010 15:48:29 -0700
From: Greg KH <gregkh@suse.de>
To: pavan_savoy@ti.com
Cc: alan@lxorguk.ukuu.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers:staging:ti-st: mv headers to ti_wilink_st
Message-ID: <20100916224829.GB14256@suse.de>
References: <1284676444-23904-1-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284676444-23904-1-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 16, 2010 at 06:34:04PM -0400, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> move all the header information to ti_wilink_st.h.
> This header would then not only serve the local modules like the st_core.c,
> st_kim.c and st_ll.c but also the external modules/protocol drivers that are
> dependent on the shared transport driver.
> Also modify the structures to use cleaner u8/u16 types for data coming
> in from chip and data parsed out of firmware.

No!

Don't do more than one thing at once please, do one thing at a time.

One patch to modify the structures.

And one patch to move things together.

thanks,

greg k-h
