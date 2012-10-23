Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814Ab2JWErZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 00:47:25 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:54898 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750885Ab2JWErY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 00:47:24 -0400
MIME-Version: 1.0
In-Reply-To: <20121022185004.GA19645@kroah.com>
References: <20121022162140.GA10021@kroah.com>
	<CAHkwNT=dvfzwHhK3wag41da3H8oahh27yAAy3-TVmGAArQ=L_A@mail.gmail.com>
	<1350927423.4238.5.camel@iscandar.digidescorp.com>
	<20121022175907.GA19113@kroah.com>
	<CAHkwNTnH-qx5rUZhVwB9cW-4wVOa-TEuO3=A158XZ7T+Y7LOPw@mail.gmail.com>
	<CAHkwNTniuL-G11c25FV5k5F_yyhOR-++OBhOahBugjeFqWzFng@mail.gmail.com>
	<20121022185004.GA19645@kroah.com>
Date: Tue, 23 Oct 2012 10:17:22 +0530
Message-ID: <CAHkwNTmqVkjnZBi01RkY3McSOHYFOvb4m82Lfrc_dVSxSoBWDg@mail.gmail.com>
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

> No, debugfs needs to be mounted at /sys/kernel/debug/  Is it not mounted
> that way for you?  Perhaps it is mounted with root-only access (default
> for 3.7-rc1 and newer kernels)?

Yes you are right i verified "/sys/kernel/debug" has root-only access.
The kernel version i am using is 3.0.0-26-generic(Default kernel
provided by ubuntu 11.10 amd64).

> I should just port the thing to use libusb instead of debugfs, but
> that's a larger job for such a low-priority tool.

If you don't mind i would like to give it a try, though most of the
terminologies i don't know but i would like to give it a try, just
guide me on way of doing it thats all.

-- 
Regards,
Anil Nair
