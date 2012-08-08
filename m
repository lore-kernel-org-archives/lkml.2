Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932440Ab2HHPZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:25:58 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:42600 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758723Ab2HHPZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:25:57 -0400
Date: Wed, 8 Aug 2012 08:25:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org,
        Richard Zhao <richard.zhao@freescale.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 03/11] usb/ohci-omap: remove unused variable
Message-ID: <20120808152545.GC15776@kroah.com>
References: <1344437248-20560-1-git-send-email-arnd@arndb.de>
 <1344437248-20560-4-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344437248-20560-4-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 08, 2012 at 04:47:20PM +0200, Arnd Bergmann wrote:
> Commit c2e935a7d "USB: move transceiver from ehci_hcd and ohci_hcd to
> hcd and rename it as phy" removed the last use of the "ohci" variable
> in the usb_hcd_omap_remove function, but left the variable in place
> unused.
> 
> Without this patch, building omap1_defconfig results in:
> 
> In file included from drivers/usb/host/ohci-hcd.c:1013:0:
> drivers/usb/host/ohci-omap.c: In function 'usb_hcd_omap_remove':
> drivers/usb/host/ohci-omap.c:406:19: warning: unused variable 'ohci' [-Wunused-variable]
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Richard Zhao <richard.zhao@freescale.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
