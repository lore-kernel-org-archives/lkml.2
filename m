Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753907Ab2HCQj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 12:39:26 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:45535 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751470Ab2HCQjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 12:39:24 -0400
X-Sasl-enc: QzqWjA6B1yT0e37K9yASavYbzUuqVhRce7vi1vpTVkRP 1344011963
Date: Fri, 3 Aug 2012 09:39:12 -0700
From: Greg KH <greg@kroah.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: Re: Build regressions/improvements in v3.5
Message-ID: <20120803163912.GA11048@kroah.com>
References: <1344002771-21072-1-git-send-email-geert@linux-m68k.org>
 <CAMuHMdXsWkXaGPoMDBEkvwWPWvYzPhn8rtbmuQZumWtWe5WGxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXsWkXaGPoMDBEkvwWPWvYzPhn8rtbmuQZumWtWe5WGxQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 04:11:23PM +0200, Geert Uytterhoeven wrote:
> On Fri, Aug 3, 2012 at 4:06 PM, Geert Uytterhoeven <geert@linux-m68k.org> wrote:
> > JFYI, when comparing v3.5 to v3.5-rc7[3], the summaries are:
> >   - build errors: +6/-9
> >   - build warnings: +105/-5443
> 
>   + drivers/staging/ccg/../../usb/gadget/f_mass_storage.c: error:
> implicit declaration of function 'get_ds'
> [-Werror=implicit-function-declaration]:  => 2624:2
>   + drivers/staging/ccg/../../usb/gadget/f_mass_storage.c: error:
> implicit declaration of function 'set_fs'
> [-Werror=implicit-function-declaration]:  => 2624:2
>   + drivers/staging/ccg/../../usb/gadget/storage_common.c: error:
> implicit declaration of function 'bdev_logical_block_size'
> [-Werror=implicit-function-declaration]:  => 686:3
>   + drivers/staging/ccg/../../usb/gadget/storage_common.c: error:
> implicit declaration of function 'blksize_bits'
> [-Werror=implicit-function-declaration]:  => 687:3
> 
> i386-randconfig, staging drivers including USB core sources?

Yeah, known problem with the usb gadget drivers.

greg k-h
