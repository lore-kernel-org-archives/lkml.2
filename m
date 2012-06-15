Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756034Ab2FODoQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 23:44:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44774 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753436Ab2FODoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 23:44:15 -0400
Date: Thu, 14 Jun 2012 20:44:10 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Anil Nair <anilcoll90@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, linux-usb@vger.kernel.org
Subject: Re: Need of automatic scripts for beginners
Message-ID: <20120615034410.GA6380@kroah.com>
References: <CAHkwNTnsVW6psWORXAEWVeQ+-ZQauY43SbE0P+be3FQD61PaOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHkwNTnsVW6psWORXAEWVeQ+-ZQauY43SbE0P+be3FQD61PaOA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 15, 2012 at 09:06:00AM +0530, Anil Nair wrote:
> Hi all,
> 
> There are lot of professionals who join in the Linux Community daily,
> But there are also people who are new to kernel configuration and
> compiling so is it possible for the community to create a automatic
> bash script so that it would be useful for beginners to start with the
> kernel compilation and installation.? I could give it a try i want
> people from the community to test it for me. Such a script exists in
> the source tree?
> 
>  Suggestions required... (And expected :) )

Try doing:
	make localmodconfig
	make oldconfig
	make -j4
	make modules_install install

then reboot.

If your distro is set up properly, that should be all that you need to
do.

If not, do 'make help' and look at what you have there.

good luck,

greg k-h
