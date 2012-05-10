Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839Ab2EJXEw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 19:04:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37774 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932800Ab2EJXEu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 19:04:50 -0400
Date: Thu, 10 May 2012 16:04:45 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
Message-ID: <20120510230445.GA11918@kroah.com>
References: <20120509220636.GA27659@kroah.com>
 <4FAAECB7.8070904@hrz.tu-chemnitz.de>
 <20120509222411.GA24302@kroah.com>
 <4FAAF1C4.2050500@hrz.tu-chemnitz.de>
 <20120509235723.GA7404@ioremap.net>
 <20120510000126.GA2357@kroah.com>
 <20120510004350.GA8362@ioremap.net>
 <4FAB4A4D.8080901@hrz.tu-chemnitz.de>
 <20120510151639.GE17472@kroah.com>
 <4FAC47F6.6080903@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAC47F6.6080903@hrz.tu-chemnitz.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 11, 2012 at 12:57:58AM +0200, Markus Franke wrote:
> Dear Greg,
> 
> Am 10.05.2012 17:16, schrieb Greg KH:
> 
> > I don't remember anything anymore, you will have to send the patch for
> > me to be able to properly review it and determine this.
> 
> 
> here comes the updated patch.
> 
> >From 3ef34f86788bfe39fa5bdb07b7e0598d3fda1f4f Mon Sep 17 00:00:00 2001
> From: Markus Franke <franm@hrz.tu-chemnitz.de>
> Date: Fri, 11 May 2012 00:41:35 +0200
> Subject: [PATCH] Add 1-wire slave device driver for DS28E04-100
> 
> 
> Signed-off-by: Markus Franke <franm@hrz.tu-chemnitz.de>
> ---
>  Documentation/w1/slaves/w1_ds28e04 |   36 +++
>  drivers/w1/slaves/Kconfig          |   13 +
>  drivers/w1/slaves/Makefile         |    1 +
>  drivers/w1/slaves/w1_ds28e04.c     |  476 ++++++++++++++++++++++++++++++++++++
>  drivers/w1/w1_family.h             |    1 +
>  5 files changed, 527 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/w1/slaves/w1_ds28e04
>  create mode 100644 drivers/w1/slaves/w1_ds28e04.c

You forgot a Documentation/ABI/ update that shows your sysfs files and
explains them there.

Care to retry?

greg k-h
