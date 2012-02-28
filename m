Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965889Ab2B1R6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 12:58:12 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46865 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965746Ab2B1R6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 12:58:08 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of gregkh@linuxfoundation.org designates 10.68.129.73 as permitted sender) smtp.mail=gregkh@linuxfoundation.org
Date: Tue, 28 Feb 2012 09:57:35 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Roland Stigge <stigge@antcom.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de
Subject: Re: [PATCH v3] ARM: LPC32xx: USB Support
Message-ID: <20120228175735.GB14290@kroah.com>
References: <1330178224-24999-1-git-send-email-stigge@antcom.de>
 <1330178224-24999-2-git-send-email-stigge@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1330178224-24999-2-git-send-email-stigge@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 25, 2012 at 02:57:04PM +0100, Roland Stigge wrote:
> This patch adds OHCI support to the LPC32xx ARM platform. Besides the trivial
> addition of platform "usb-ohci" support, fixes for the USB PLL have been added
> to arch/arm/mach-lpc32xx/clock.c, ported from NXP's lpclinux.com.
> 
> (This is the mach-lpc32xx specific part, the USB subsystem specific changes are
> in a separate patch for the USB maintainers.)

Do you want/need me to take both of these?  Or just the first one?  Or,
just ack the first one so the arm maintainers can take this one?  It's
your choice...

thanks,

greg k-h
