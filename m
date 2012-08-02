Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754537Ab2HBLAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 07:00:17 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:62818 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154Ab2HBLAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 07:00:15 -0400
Date: Thu, 2 Aug 2012 04:00:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        praveen.nadahally@stericsson.com
Subject: Re: [PATCH] usb:musb:musb_host: Handle highmem in PIO mode
Message-ID: <20120802110010.GA5443@kroah.com>
References: <1343889402-7826-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343889402-7826-1-git-send-email-virupax.sadashivpetimath@stericsson.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 12:06:42PM +0530, Virupax Sadashivpetimath wrote:
> In case of USB bulk transfer, when himem page
> is received, the usb_sg_init function sets the
> urb transfer buffer to NULL. When such URB
> transfer is handled, kernel crashes in PIO mode.
> Handle this by mapping the highmem buffer in PIO mode.
> 
> Signed-off-by: Virupax Sadashivpetimath <virupax.sadashivpetimath@stericsson.com>

Why is this not a problem in any other host controller?  Are you sure
this fix is correct?  Why do you need to modify the struct urb for this?

greg k-h
