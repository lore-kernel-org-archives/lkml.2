Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab1BDT7H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 14:59:07 -0500
Received: from kroah.org ([198.145.64.141]:37322 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752355Ab1BDT7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 14:59:06 -0500
Date: Fri, 4 Feb 2011 11:35:11 -0800
From: Greg KH <greg@kroah.com>
To: Vadim Tsozik <vtsozik@optimum.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Pete Zaitcev <zaitcev@redhat.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vadim Tsozik <tsozik@yahoo.com>
Subject: Re: [PATCH 1/1] mct_u232: added _ioctl, _msr_to_icount and
 _get_icount functions
Message-ID: <20110204193511.GA13617@kroah.com>
References: <201101130334.p0D3Yrw8003929@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101130334.p0D3Yrw8003929@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 12, 2011 at 10:34:53PM -0500, Vadim Tsozik wrote:
> Greg,
> I apologize for the delay. Finally I managed to configure sendmail to relay messages via my ISP SMTP (Too bad, my ISP blocks port 25).
> Below you can find patch generated off your 2.6.37-rc7 usb branch. Please let me know if you have any problem to apply this.
> Thank you in advance,

In the future, you need to create a patch that can be applied with '-p1'
option from the root of the kernel tree, right now you created it at the
root of the drivers/usb/ directory:

> --- usb/serial/mct_u232.c.orig	2010-12-26 16:54:16.660294924 -0500
> +++ usb/serial/mct_u232.c	2010-12-27 15:29:30.895141755 -0500

I edited it by hand and now applied it, sorry for the delay.

greg k-h
