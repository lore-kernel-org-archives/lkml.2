Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934312Ab2JXC7b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 22:59:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:56693 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934284Ab2JXC73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 22:59:29 -0400
Date: Tue, 23 Oct 2012 20:00:02 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anil Nair <anilcoll90@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Steven J. Magnani" <steve@digidescorp.com>
Subject: Re: usbview 2.0 release
Message-ID: <20121024030002.GB7982@kroah.com>
References: <20121022162140.GA10021@kroah.com>
 <CAHkwNT=dvfzwHhK3wag41da3H8oahh27yAAy3-TVmGAArQ=L_A@mail.gmail.com>
 <1350927423.4238.5.camel@iscandar.digidescorp.com>
 <20121022175907.GA19113@kroah.com>
 <CAHkwNTnH-qx5rUZhVwB9cW-4wVOa-TEuO3=A158XZ7T+Y7LOPw@mail.gmail.com>
 <CAHkwNTniuL-G11c25FV5k5F_yyhOR-++OBhOahBugjeFqWzFng@mail.gmail.com>
 <20121022185004.GA19645@kroah.com>
 <CAHkwNTmqVkjnZBi01RkY3McSOHYFOvb4m82Lfrc_dVSxSoBWDg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHkwNTmqVkjnZBi01RkY3McSOHYFOvb4m82Lfrc_dVSxSoBWDg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 10:17:22AM +0530, Anil Nair wrote:
> Hello Greg,
> 
> > No, debugfs needs to be mounted at /sys/kernel/debug/  Is it not mounted
> > that way for you?  Perhaps it is mounted with root-only access (default
> > for 3.7-rc1 and newer kernels)?
> 
> Yes you are right i verified "/sys/kernel/debug" has root-only access.
> The kernel version i am using is 3.0.0-26-generic(Default kernel
> provided by ubuntu 11.10 amd64).
> 
> > I should just port the thing to use libusb instead of debugfs, but
> > that's a larger job for such a low-priority tool.
> 
> If you don't mind i would like to give it a try, though most of the
> terminologies i don't know but i would like to give it a try, just
> guide me on way of doing it thats all.

Look at how the lsusb tool walks the list of all USB devices in the
system, using libusb, and port that code over to usbview, replacing the
big "walk and parse the devices file" functionality.

It shouldn't be that hard, if you run into any problems, please let me
know.

thanks,

greg k-h
