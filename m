Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab2JXQlS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:41:18 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:46145 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753681Ab2JXQlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:41:15 -0400
Date: Wed, 24 Oct 2012 09:41:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anil Nair <anilcoll90@gmail.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Steven J. Magnani" <steve@digidescorp.com>
Subject: Re: usbview 2.0 release
Message-ID: <20121024164112.GA2499@kroah.com>
References: <20121022162140.GA10021@kroah.com>
 <CAHkwNT=dvfzwHhK3wag41da3H8oahh27yAAy3-TVmGAArQ=L_A@mail.gmail.com>
 <1350927423.4238.5.camel@iscandar.digidescorp.com>
 <20121022175907.GA19113@kroah.com>
 <CAHkwNTnH-qx5rUZhVwB9cW-4wVOa-TEuO3=A158XZ7T+Y7LOPw@mail.gmail.com>
 <CAHkwNTniuL-G11c25FV5k5F_yyhOR-++OBhOahBugjeFqWzFng@mail.gmail.com>
 <20121022185004.GA19645@kroah.com>
 <CAHkwNTmqVkjnZBi01RkY3McSOHYFOvb4m82Lfrc_dVSxSoBWDg@mail.gmail.com>
 <20121024030002.GB7982@kroah.com>
 <CAHkwNTnkEANzDe9mUCtrTgE3LLphtr0XENQfC9-J02ygH=-VEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHkwNTnkEANzDe9mUCtrTgE3LLphtr0XENQfC9-J02ygH=-VEA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 10:05:48PM +0530, Anil Nair wrote:
> Hello Greg,
> 
> > Look at how the lsusb tool walks the list of all USB devices in the
> > system, using libusb, and port that code over to usbview, replacing the
> > big "walk and parse the devices file" functionality.
> >
> 
> You meant to say replace the functions calling or using debugfs by
> API's of libusb?

Yes.  But note, the debugfs "usage" is just reading a single file and
parsing the structure of that file and filling out an internal "tree" of
USB devices.  So moving that to use libusb should be pretty simple.

> Well i will try working on it, but i can't say a sure time when it
> will be completed..... i know working of USB just need to go through
> libusb API's and some examples.

Again, look at the usbutils source code, it does most of this for you
already, and you can take the code from there since the license is the
same.

good luck,

greg k-h
