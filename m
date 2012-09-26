Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755574Ab2IZU2S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 16:28:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44552 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754461Ab2IZU2Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 16:28:16 -0400
Date: Wed, 26 Sep 2012 13:28:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Rene Buergel <rene.buergel@sohard.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [Patch v5] ezusb: move ezusb.c from drivers/usb/serial to
 drivers/usb/misc
Message-ID: <20120926202812.GA9728@kroah.com>
References: <c28594f9-45a3-4232-82fc-2f7c65cfb30c@shmail0>
 <47b117b0-5776-41c4-8b49-e3a21e80a6a4@shmail0>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47b117b0-5776-41c4-8b49-e3a21e80a6a4@shmail0>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 26, 2012 at 10:20:19PM +0200, Rene Buergel wrote:
> This patch 
> - moves drivers/usb/serial/ezusb.c to drivers/usb/misc/
> - renamed CONFIG_USB_EZUSB to CONFIG_USB_EZUSB_FX2 to avoid build errors

Ah, does this solve the error I was seeing?  Nice job figuring that one
out.

greg k-h
