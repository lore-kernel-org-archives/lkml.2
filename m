Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab2EJAny (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 20:43:54 -0400
Received: from genesysrack.ru ([195.178.208.66]:45342 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756907Ab2EJAnw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 20:43:52 -0400
Date: Thu, 10 May 2012 04:43:50 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Greg KH <greg@kroah.com>
Cc: Markus Franke <markus.franke@s2002.tu-chemnitz.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] w1: Add 1-wire slave device driver for DS28E04-100
Message-ID: <20120510004350.GA8362@ioremap.net>
References: <4FA1953B.40008@hrz.tu-chemnitz.de>
 <20120502202134.GB26628@kroah.com>
 <20120503180056.GB13988@ioremap.net>
 <4FAAD584.70102@hrz.tu-chemnitz.de>
 <20120509220636.GA27659@kroah.com>
 <4FAAECB7.8070904@hrz.tu-chemnitz.de>
 <20120509222411.GA24302@kroah.com>
 <4FAAF1C4.2050500@hrz.tu-chemnitz.de>
 <20120509235723.GA7404@ioremap.net>
 <20120510000126.GA2357@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120510000126.GA2357@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 05:01:26PM -0700, Greg KH (greg@kroah.com) wrote:
> Binary sysfs files should be "pass through" only, the kernel should not
> touch the data involved in them at all, it is a pipe directly from the
> kernel to userspace for binary blob data, like firmware images.  You
> should never do any processing of any binary file data at all in the
> kernel.

And if some of the data should be somehow changed, what interfact should
be used? Also, Markus, does DS28E04 change written/read data when doing
IO?

I must admit, I never heared that binary sysfs files have to follow this
constraint.

-- 
	Evgeniy Polyakov
