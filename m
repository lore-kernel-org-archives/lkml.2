Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab1CIXog (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 18:44:36 -0500
Received: from kroah.org ([198.145.64.141]:45197 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751649Ab1CIXoe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 18:44:34 -0500
Date: Wed, 9 Mar 2011 15:39:46 -0800
From: Greg KH <greg@kroah.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: dbrownell@users.sourceforge.net, gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb-gadget: unlock data->lock mutex on error path in
 ep_read()
Message-ID: <20110309233946.GA31857@kroah.com>
References: <4D772F2B.6030209@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D772F2B.6030209@ispras.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 10:41:31AM +0300, Alexey Khoroshilov wrote:
> ep_read() acquires data->lock mutex in get_ready_ep() and releases it on
> all paths except for one: when usb_endpoint_xfer_isoc() failed. The
> patch adds mutex_unlock(&data->lock) at that path.
> 
> Found by Linux Driver Verification project (linuxtesting.org).
> 
> Signed-off-by: Alexey Khoroshilov<khoroshilov@ispras.ru>

Need a space after your name and before the email address.

Anyway, your patch is still line-wrapped and the leading spaces stripped
off, making it impossible to apply.  After hand-editing it, it still
fails, are you sure you made this against the linux-next tree?

Care to try again?

thanks,

greg k-h
