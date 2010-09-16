Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756114Ab0IPUEl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 16:04:41 -0400
Received: from kroah.org ([198.145.64.141]:43190 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756019Ab0IPUEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 16:04:24 -0400
Date: Thu, 16 Sep 2010 12:57:27 -0700
From: Greg KH <greg@kroah.com>
To: pavan_savoy@ti.com
Cc: gregkh@suse.de, alan@lxorguk.ukuu.org.uk, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 2/3] drivers:staging:ti-st: mv ti_wilink_st to include/
Message-ID: <20100916195727.GH10397@kroah.com>
References: <1284148738-21643-1-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-2-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-3-git-send-email-pavan_savoy@ti.com>
 <1284148738-21643-4-git-send-email-pavan_savoy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1284148738-21643-4-git-send-email-pavan_savoy@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 03:58:57PM -0400, pavan_savoy@ti.com wrote:
> From: Pavan Savoy <pavan_savoy@ti.com>
> 
> Move the ti_wilink_st header (previously st.h) to include/linux
> directory. This header is to be included by all protocol drivers viz'
> bluetooth drivers, FM V4L2 and GPS generic character device driver.
> It also serves the core shared transport driver.

Ah, so the individual drivers will be in the different parts of the
kernel?  Like drivers/char and other places?  That makes sense why they
should be using a file in include/linux/

But just make the file that name now, in the staging directory.  That
way when we move the code out, it's easier to do so (we don't have to do
this 3 patch series.)

thanks,

greg k-h
