Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760055Ab2CTOBQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:01:16 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:34062 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758036Ab2CTOBP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:01:15 -0400
Date: Tue, 20 Mar 2012 07:01:11 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: nico <nico@meiwaku.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] New product ID for pl2303.ko (USB serial device)
Message-ID: <20120320140111.GD4634@kroah.com>
References: <20120319234949.77ab0a4c.nico@meiwaku.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120319234949.77ab0a4c.nico@meiwaku.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 11:49:49PM +0900, nico wrote:
>    Please add a new product ID to drivers/usb/serial/pl2303.h and pl2303.c.
> It works fine on Linux 2.6.32 (Ubuntu 10.04.4 LTS).

Can you redo this patch on the 3.3 kernel tree, and resend it, after
reading Documentation/SubmittingPatches and running the patch through
the scripts/checkpatch.pl tool?

Also be sure to properly cc: the needed people (i.e. in this case, me.)

thanks,

greg k-h
