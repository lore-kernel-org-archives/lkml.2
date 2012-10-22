Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab2JVSjE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 14:39:04 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:61949 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755771Ab2JVSjB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 14:39:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAHkwNTnH-qx5rUZhVwB9cW-4wVOa-TEuO3=A158XZ7T+Y7LOPw@mail.gmail.com>
References: <20121022162140.GA10021@kroah.com>
	<CAHkwNT=dvfzwHhK3wag41da3H8oahh27yAAy3-TVmGAArQ=L_A@mail.gmail.com>
	<1350927423.4238.5.camel@iscandar.digidescorp.com>
	<20121022175907.GA19113@kroah.com>
	<CAHkwNTnH-qx5rUZhVwB9cW-4wVOa-TEuO3=A158XZ7T+Y7LOPw@mail.gmail.com>
Date: Tue, 23 Oct 2012 00:09:00 +0530
Message-ID: <CAHkwNTniuL-G11c25FV5k5F_yyhOR-++OBhOahBugjeFqWzFng@mail.gmail.com>
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

I had only one doubt though the tool seems to work for rooted users only?
when i try to launch it as a normal user it gives me error saying,

"
Can not open the file /sys/kernel/debug/usb/devices

 Verify that you have USB compiled into your kernel,
 have the USB core modules loaded, and have the
 usbdevfs filesystem mounted

"

That problem gets solved when using root user, is it because of the
reason that i have to mount usbdevfs for my current user?
The earlier usbview v1.1 tool required that that is why i am asking you.


--
Regrads,
Anil Nair
