Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759548Ab0GVOOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 10:14:36 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49115 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759439Ab0GVOOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 10:14:34 -0400
Date: Thu, 22 Jul 2010 10:14:32 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <m.nazarewicz@samsung.com>
cc: linux-usb@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>,
        <linux-kernel@vger.kernel.org>, Yann Cantin <yann.cantin@laposte.net>
Subject: Re: [PATCHv4 5/5] USB: gadget: file_storage: serial parameter even
 if not test mode
In-Reply-To: <709d887b2249e9651060729eb62b29a1d3edc256.1279794290.git.m.nazarewicz@samsung.com>
Message-ID: <Pine.LNX.4.44L0.1007221014090.1725-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010, Michal Nazarewicz wrote:

> Moved the serial parameter handling code out of "#ifdef
> CONFIG_USB_FILE_STORAGE_TEST".
> 
> This modifies Yann Cantin's commit "USB: Add a serial number
> parameter to g_file_storage" module as per Alan Stern's request.
> 
> Signed-off-by: Michal Nazarewicz <m.nazarewicz@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Yann Cantin <yann.cantin@laposte.net>
> ---
> Alan Stern wrote:
> > I have only one objection to this [Yann Cantin's] patch: The new
> > parameter's name should be "serial", not "serial_parm".
> 
> Alan Stern wrote:
> > The serial number parameter is important enough that it should be
> > available even on builds without CONFIG_USB_FILE_STORAGE_TEST.
> 
>  drivers/usb/gadget/file_storage.c |   20 +++++++++++---------
>  1 files changed, 11 insertions(+), 9 deletions(-)

Acked-by: Alan Stern <stern@rowland.harvard.edu>

