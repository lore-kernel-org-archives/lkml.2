Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935242Ab2JXQfv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:35:51 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34470 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932324Ab2JXQft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:35:49 -0400
MIME-Version: 1.0
In-Reply-To: <20121024030002.GB7982@kroah.com>
References: <20121022162140.GA10021@kroah.com>
	<CAHkwNT=dvfzwHhK3wag41da3H8oahh27yAAy3-TVmGAArQ=L_A@mail.gmail.com>
	<1350927423.4238.5.camel@iscandar.digidescorp.com>
	<20121022175907.GA19113@kroah.com>
	<CAHkwNTnH-qx5rUZhVwB9cW-4wVOa-TEuO3=A158XZ7T+Y7LOPw@mail.gmail.com>
	<CAHkwNTniuL-G11c25FV5k5F_yyhOR-++OBhOahBugjeFqWzFng@mail.gmail.com>
	<20121022185004.GA19645@kroah.com>
	<CAHkwNTmqVkjnZBi01RkY3McSOHYFOvb4m82Lfrc_dVSxSoBWDg@mail.gmail.com>
	<20121024030002.GB7982@kroah.com>
Date: Wed, 24 Oct 2012 22:05:48 +0530
Message-ID: <CAHkwNTnkEANzDe9mUCtrTgE3LLphtr0XENQfC9-J02ygH=-VEA@mail.gmail.com>
Subject: Re: usbview 2.0 release
From: Anil Nair <anilcoll90@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Steven J. Magnani" <steve@digidescorp.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Greg,

> Look at how the lsusb tool walks the list of all USB devices in the
> system, using libusb, and port that code over to usbview, replacing the
> big "walk and parse the devices file" functionality.
>

You meant to say replace the functions calling or using debugfs by
API's of libusb?
Well i will try working on it, but i can't say a sure time when it
will be completed..... i know working of USB just need to go through
libusb API's and some examples.


-- 
Regards,
Anil Nair
