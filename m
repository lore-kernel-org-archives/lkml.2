Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754247Ab2CMQJ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:09:59 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:45565 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab2CMQJ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:09:57 -0400
Date: Tue, 13 Mar 2012 09:09:51 -0700
From: "'Greg KH'" <gregkh@linuxfoundation.org>
To: Donald <donald@asix.com.tw>
Cc: "'open list:USB SUBSYSTEM'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] x86: Fixed MCS7820 device attach problem
Message-ID: <20120313160951.GA18810@kroah.com>
References: <009c01cd00ee$924eb2e0$b6ec18a0$@com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <009c01cd00ee$924eb2e0$b6ec18a0$@com.tw>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 03:54:46PM +0800, Donald wrote:
> A MCS7820 device supports two serial ports and a MCS7840 device supports
> four serial ports. Both devices use the same driver, but the attach function
> in driver was unable to correctly handle the port numbers for MCS7820
> device. This problem has been fixed in this patch and this fix has been
> verified on x86 Linux kernel 3.2.9 with both MCS7820 and MCS7840 devices.
> 
> Signed-off-by: Donald Lee <donald@asix.com.tw> 
> 
> --- 
>  drivers/usb/serial/mos7840.c |   83
> +++++++++++++++++++++++++++++------------- 

This is great, but your email client turned the tabs into spaces and
line-wrapped the patch, and added trailing spaces on every line, making
this impossible to apply :(

Care to read Documentation/email_clients.txt and resend it after fixing
things up on your end?

And this isn't limited to x86, so you don't need that in the subject:
line, it's a USB issue for all platforms.

thanks,

greg k-h
