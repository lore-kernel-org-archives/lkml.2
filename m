Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab2JERyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 13:54:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57515 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754229Ab2JERyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 13:54:53 -0400
Date: Fri, 5 Oct 2012 13:54:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Fainelli <florian@openwrt.org>
cc: USB list <linux-usb@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/32] USB: OHCI: remove ohci-pcc-soc driver.
In-Reply-To: <1349454064-11606-3-git-send-email-florian@openwrt.org>
Message-ID: <Pine.LNX.4.44L0.1210051327090.1541-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2012, Florian Fainelli wrote:

> This driver is not registered by any in-tree users, and if really needed by
> some out of tree user, the same functionnality can be restored using the
> ohci-platform driver using the following platform_data parameters:
> 	big_endian_desc = 1
> 	big_endian_mmio = 1
> 	no_big_frame_no = 1
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> ---
>  drivers/usb/host/ohci-hcd.c     |    5 -
>  drivers/usb/host/ohci-ppc-soc.c |  216 ---------------------------------------

>  2 files changed, 221 deletions(-)

You forgot to remove the corresponding entry from Kconfig.

Alan Stern

