Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab2JXFmE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 01:42:04 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:59920 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2JXFmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 01:42:02 -0400
Date: Tue, 23 Oct 2012 22:42:36 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 2/2] firmware loader: introduce kernel parameter to
 customize fw search path
Message-ID: <20121024054236.GA14826@kroah.com>
References: <1351046993-2220-1-git-send-email-ming.lei@canonical.com>
 <20121024031845.GA11255@kroah.com>
 <CACVXFVNAWcNgf94mY24c7r2jwtciekz=N-Yw_PyY9-4sT+BL_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVNAWcNgf94mY24c7r2jwtciekz=N-Yw_PyY9-4sT+BL_Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 11:31:16AM +0800, Ming Lei wrote:
> On Wed, Oct 24, 2012 at 11:18 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > Ick, no, not another kernel boot parameter.  I would prefer the /proc/
> > file solution instead, just like /proc/sys/kernel/hotplug is.
> 
> OK, got it, but we could use the module parameter(firmware_class.path
> via kernel command) to customize the search path too, couldn't we?

Yes, but why?  Let's not overdesign this, get the basics working and
then, if someone really needs it, we can add it.

thanks,

greg k-h
