Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756848Ab2D3UcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 16:32:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53512 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756738Ab2D3UcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 16:32:21 -0400
Date: Mon, 30 Apr 2012 16:32:15 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Preston Fick <pffick@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, preston.fick@silabs.com
Subject: Re: [PATCH] usb: cp210x: Added support for GPIO (CP2103/4/5)
Message-ID: <20120430203215.GA15589@kroah.com>
References: <1335817637-2862-1-git-send-email-preston.fick@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335817637-2862-1-git-send-email-preston.fick@silabs.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 03:27:17PM -0500, Preston Fick wrote:
> This fix contains several changes that allow toggling of GPIO on CP210x
> devices that support it. Changes include:
> * Added in part number support, necessary to see if the connected device
> supports the GPIO functionality
> * Added two IOCTLs and ioctl function to allow GET/SET of GPIO
> * Added in new #defines for partnum support, new USB requests
> * Changed "Config request types" section to contain more correct definitions
> for request recipient

No, please break this out into one-patch-per-change, don't bundle all of
this together into one, as I can't take it as-is, sorry.

Especially with those new ioctls...

thanks,

greg k-h
