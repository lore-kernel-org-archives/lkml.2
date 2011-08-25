Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab1HYQAa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 12:00:30 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47294 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751904Ab1HYQA2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 12:00:28 -0400
X-Sasl-enc: XCo9AfbfWiLH0CVUGmABSJqrUy0uolFpwDJguXUyzpfX 1314288027
Date: Thu, 25 Aug 2011 08:50:50 -0700
From: Greg KH <greg@kroah.com>
To: Timur Tabi <timur@freescale.com>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org
Subject: Re: [PATCH] [v4] tty/powerpc: introduce the ePAPR embedded
 hypervisor byte channel driver
Message-ID: <20110825155050.GA10084@kroah.com>
References: <1314286345-27056-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314286345-27056-1-git-send-email-timur@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 10:32:25AM -0500, Timur Tabi wrote:
> The ePAPR embedded hypervisor specification provides an API for "byte
> channels", which are serial-like virtual devices for sending and receiving
> streams of bytes.  This driver provides Linux kernel support for byte
> channels via three distinct interfaces:
> 
> 1) An early-console (udbg) driver.  This provides early console output
> through a byte channel.  The byte channel handle must be specified in a
> Kconfig option.
> 
> 2) A normal console driver.  Output is sent to the byte channel designated
> for stdout in the device tree.  The console driver is for handling kernel
> printk calls.
> 
> 3) A tty driver, which is used to handle user-space input and output.  The
> byte channel used for the console is designated as the default tty.
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>

No, this doesn't work, I need just a fix, as I took your previous patch
already.

greg k-h
