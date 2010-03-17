Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab0CQEk7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 00:40:59 -0400
Received: from cantor.suse.de ([195.135.220.2]:57501 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752670Ab0CQEk6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 00:40:58 -0400
Date: Tue, 16 Mar 2010 21:39:10 -0700
From: Greg KH <gregkh@suse.de>
To: Christopher Hoover <ch@murgatroid.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Patch for B&B Electronics USPLT4-LS
Message-ID: <20100317043910.GA21532@suse.de>
References: <4BA03A1A.50204@murgatroid.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA03A1A.50204@murgatroid.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 16, 2010 at 07:10:34PM -0700, Christopher Hoover wrote:
> Adds support for B&B Electronics USPLT4-LS.

Can you resend this with a "Signed-off-by:" line so that I can apply the
patch?  The file, Documentation/SubmittingPatches shows what is needed
here.

> diff --exclude='*~' -Naur linux-2.6.30.orig/drivers/usb/serial/ftdi_sio.c linux-2.6.30/drivers/usb/serial/ftdi_sio.c

Can you make the patch against 2.6.33 or even 2.6.34-rc1 if possible?
The code in this area has changed so you will have to move your patch
around a bit.

thanks,

greg k-h
