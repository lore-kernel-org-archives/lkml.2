Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754385Ab1BCWVC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 17:21:02 -0500
Received: from kroah.org ([198.145.64.141]:59597 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754257Ab1BCWUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 17:20:54 -0500
Date: Thu, 3 Feb 2011 14:20:06 -0800
From: Greg KH <greg@kroah.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: linux-serial@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        uclinux-dist-devel@blackfin.uclinux.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] drivers: char: hvc: add Blackfin JTAG console support
Message-ID: <20110203222006.GA12859@kroah.com>
References: <1294713837-4929-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294713837-4929-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 10, 2011 at 09:43:57PM -0500, Mike Frysinger wrote:
> This converts the existing bfin_jtag_comm TTY driver to the HVC layer so
> that the common HVC code can worry about all of the TTY/polling crap and
> leave the Blackfin code to worry about the Blackfin bits.

This patch no longer applies to the linux-next tree.  Can you redo it
and resend it?

thanks,

greg k-h
