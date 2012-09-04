Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932312Ab2IDOes (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 10:34:48 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:56324 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932285Ab2IDOeq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 10:34:46 -0400
Date: Tue, 4 Sep 2012 10:34:44 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Nicolas Ferre <nicolas.ferre@atmel.com>
cc: gregkh@linuxfoundation.org, <linux-usb@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <plagnioj@jcrosoft.com>, <klaus.falkner@solectrix.de>,
        <ludovic.desroches@atmel.com>
Subject: Re: [PATCH] USB: ohci-at91: fix PIO handling in relation with number
 of ports
In-Reply-To: <5045BB6A.8060309@atmel.com>
Message-ID: <Pine.LNX.4.44L0.1209041032520.1605-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 Sep 2012, Nicolas Ferre wrote:

> On 08/29/2012 11:49 AM, Nicolas Ferre :
> > If the number of ports present on the SoC/board is not the maximum
> > and that the platform data is not filled with all data, there is
> > an easy way to mess the PIO setup for this interface.
> > This quick fix addresses mis-configuration in USB host platform data
> > that is common in at91 boards since commit 0ee6d1e (USB: ohci-at91:
> > change maximum number of ports) that did not modified the associatd
> > board files.
> > 
> > Reported-by: Klaus Falkner <klaus.falkner@solectrix.de>
> > Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
> > Cc: Alan Stern <stern@rowland.harvard.edu>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: linux-usb@vger.kernel.org
> > Cc: Stable <stable@vger.kernel.org> [3.4+]
> 
> Alan, Greg, gentle ping...
> 
> I really would like to seen it landing in stable soon...
> 
> Thanks, best regards,

Sorry for the delay.  I feel a little uncomfortable judging board-level 
changes like this, since I know nothing about the hardware details.

Still, for what it's worth, this patch is okay as far as the core 
ohci-hcd driver components are concerned.  So...

Acked-by: Alan Stern <stern@rowland.harvard.edu>

