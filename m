Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab2FFILs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 04:11:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56158 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750942Ab2FFILq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 04:11:46 -0400
Date: Wed, 6 Jun 2012 17:11:35 +0900
From: Greg KH <gregkh@linuxfoundation.org>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, oneukum@suse.de, alan@lxorguk.ukuu.org.uk
Subject: Re: [PATCH] fix usb skeleton driver
Message-ID: <20120606081135.GA7306@kroah.com>
References: <1338966036-30443-1-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1338966036-30443-1-git-send-email-stefani@seibold.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 06, 2012 at 09:00:36AM +0200, stefani@seibold.net wrote:
> From: Stefani Seibold <stefani@seibold.net>
> 
> This is a fix for the USB skeleton driver to bring it in shape.
> 
> - The usb_device structure pointer will no longer stored 
> - Every access to the USB will be handled trought the usb_interface pointer
> - No longer assign a NULL to usb_interface pointer in the disconnect() handler
> - Add a new bool 'connected' for signaling a disconnect (== false)
> - Handle a non blocking read without blocking
> - Code clean up

Please break this up into individual patches for all of these things,
and also always cc: the linux-usb@vger.kernel.org mailing list when you
submit USB related patches.

thanks,

greg k-h
