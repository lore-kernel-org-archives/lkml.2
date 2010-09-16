Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756079Ab0IPUEY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 16:04:24 -0400
Received: from kroah.org ([198.145.64.141]:43185 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525Ab0IPUEX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 16:04:23 -0400
Date: Thu, 16 Sep 2010 12:56:01 -0700
From: Greg KH <greg@kroah.com>
To: pavan_savoy@ti.com
Cc: gregkh@suse.de, alan@lxorguk.ukuu.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/3] drivers:staging:ti-st: mv headers to ti_wilink_st
Message-ID: <20100916195601.GG10397@kroah.com>
References: <1284148738-21643-1-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-2-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-3-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284148738-21643-3-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 03:58:56PM -0400, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> Move all headers to st.h and rename st.h to be ti_wilink_st.h,
> prepare the file to be moved to include/linux/ directory.

Why does the file need to be in include/linux/ at all?  Can't it just
live in the same directory as the drivers?

And this patch doesn't rename st.h to be anything else.

thanks,

greg k-h
