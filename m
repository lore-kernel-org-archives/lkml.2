Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754391Ab2JOSTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 14:19:41 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:43224 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab2JOSTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 14:19:39 -0400
Date: Mon, 15 Oct 2012 11:19:28 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Roland Stigge <stigge@antcom.de>, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, highguy@gmail.com,
        broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC 2/6 v3] gpio: Add sysfs support to block GPIO API
Message-ID: <20121015181928.GB27923@kroah.com>
References: <1350069085-13283-1-git-send-email-stigge@antcom.de>
 <1350069085-13283-3-git-send-email-stigge@antcom.de>
 <20121015180702.GA12801@game.jcrosoft.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121015180702.GA12801@game.jcrosoft.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 15, 2012 at 08:07:02PM +0200, Jean-Christophe PLAGNIOL-VILLARD wrote:
> On 21:11 Fri 12 Oct     , Roland Stigge wrote:
> > This patch adds sysfs support to the block GPIO API.
> > 
> > Signed-off-by: Roland Stigge <stigge@antcom.de>
> > 
> > ---
> >  Documentation/ABI/testing/sysfs-gpio |    6 
> >  drivers/gpio/gpiolib.c               |  226 ++++++++++++++++++++++++++++++++++-
> >  include/asm-generic/gpio.h           |   11 +
> >  include/linux/gpio.h                 |   13 ++
> >  4 files changed, 254 insertions(+), 2 deletions(-)
> I really don't like this sysfs we need to add a specific device with ioctl

Why?

> I put Greg in Cc

Again, why?

greg k-h
