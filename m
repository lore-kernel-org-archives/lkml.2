Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757072Ab0JEUHn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 16:07:43 -0400
Received: from kroah.org ([198.145.64.141]:52984 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756824Ab0JEUH3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 16:07:29 -0400
Date: Tue, 5 Oct 2010 13:06:49 -0700
From: Greg KH <greg@kroah.com>
To: "Savoy, Pavan" <pavan_savoy@ti.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] prepare TI_ST to move out of staging
Message-ID: <20101005200649.GA4228@kroah.com>
References: <1285877610-3043-1-git-send-email-pavan_savoy@ti.com>
 <20101005184925.GA20825@kroah.com>
 <19F8576C6E063C45BE387C64729E739404AA21CB20@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19F8576C6E063C45BE387C64729E739404AA21CB20@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 06, 2010 at 12:27:46AM +0530, Savoy, Pavan wrote:
> > So, on to moving the drivers out of the staging tree, right?  Care to
> > send me patches for them?  Have you gotten the bluetooth driver reviewed
> > yet?
> 
> No not yet.
> I had planned to put up a patch to move the st_core.c, st_kim.c and
> st_ll.c to drivers/misc/ first.

That is fine.

> Then put together Bluetooth header and driver where in I will bring in
> Marcel/Johan & linux-bluetooth into the loop.  Then move the unified
> bt_drv.c to something like ti_st_bt.c to drivers/bluetooth/
> 
> Does this sound OK?

Yes it does.  Feel free to send patches for the first part above on if
you want to.

thanks,

greg k-h
