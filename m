Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752707Ab2GITdi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 15:33:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60864 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752057Ab2GITdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 15:33:33 -0400
Date: Mon, 9 Jul 2012 12:33:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Toshiaki Yamane <yamanetoshi@gmail.com>
Cc: sjakub@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH] asus_oled: Use pr_err(...) rather than
 printk(KERN_ERR ...)
Message-ID: <20120709193329.GA13214@kroah.com>
References: <1341739547-17254-1-git-send-email-yamanetoshi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341739547-17254-1-git-send-email-yamanetoshi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 08, 2012 at 06:25:47PM +0900, Toshiaki Yamane wrote:
> This change is inspired by checkpatch.
> 
> Signed-off-by: Toshiaki Yamane <yamanetoshi@gmail.com>
> ---
>  drivers/staging/asus_oled/asus_oled.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)

Sorry, someone beat you to this very change by a few hours :(

greg k-h
