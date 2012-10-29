Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759242Ab2J2OMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:12:37 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:45244 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab2J2OMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:12:31 -0400
Date: Mon, 29 Oct 2012 07:13:24 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Oct 29 (tty->raw)
Message-ID: <20121029141324.GA23983@kroah.com>
References: <20121029144655.4a3d916780e0246f1f007c3e@canb.auug.org.au>
 <508E0345.1010600@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508E0345.1010600@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 28, 2012 at 09:17:09PM -0700, Randy Dunlap wrote:
> On 10/28/2012 08:46 PM, Stephen Rothwell wrote:
> 
> > Hi all,
> > 
> > Changes since 20121026:
> > 
> 
> 
> Who made some changes that remove tty->raw ?

Jiri did.

> There is still one occurrence in arch/um that is causing
> a build error (on x86_64 defconfig):
> 
> arch/um/drivers/chan_kern.c: In function 'tty_receive_char':
> arch/um/drivers/chan_kern.c:89:42: error: 'struct tty_struct' has no member named 'raw'

Known issue, it is being worked on.

thanks,

greg k-h
