Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab2EIWGk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 18:06:40 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:51083 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759788Ab2EIWGj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 18:06:39 -0400
X-Sasl-enc: ePeheOyZzw6ZV8QNFUdax0TSaTyxRmqc1XdNOqh/6yLr 1336601198
Date: Wed, 9 May 2012 15:06:36 -0700
From: Greg KH <greg@kroah.com>
To: Markus Franke <markus.franke@s2002.tu-chemnitz.de>
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
Message-ID: <20120509220636.GA27659@kroah.com>
References: <20120430021300.GA18148@kroah.com>
 <4FA1953B.40008@hrz.tu-chemnitz.de>
 <20120502202134.GB26628@kroah.com>
 <20120503180056.GB13988@ioremap.net>
 <4FAAD584.70102@hrz.tu-chemnitz.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAAD584.70102@hrz.tu-chemnitz.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 10:37:24PM +0200, Markus Franke wrote:
> Dear Evgeniy,
> 
> I have reworked the patch and now I am not getting any checkpatch
> warnings or errors anymore.
> 
> How about the binary sysfs files? If I understand correctly I would add
> a documentation file under Documentation/w1/slaves which documents both
> sysfs files (eeprom & pio).
> 
> @Greg: Could you live with those driver specific binary sysfs files?

Why do you need them?  What are they there for?

greg k-h
