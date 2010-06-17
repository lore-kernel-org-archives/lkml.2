Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933260Ab0FQUJn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 16:09:43 -0400
Received: from kroah.org ([198.145.64.141]:53336 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757495Ab0FQUJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 16:09:42 -0400
Date: Thu, 17 Jun 2010 13:03:28 -0700
From: Greg KH <greg@kroah.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Jeff Dike <jdike@addtoit.com>, Alan Cox <alan@linux.intel.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove Hayes ESP ioctls
Message-ID: <20100617200328.GA25977@kroah.com>
References: <20100617160045.GA13743@c-98-229-117-200.hsd1.ma.comcast.net>
 <20100617172828.GA24362@kroah.com>
 <20100617191516.GA15963@c-98-229-117-200.hsd1.ma.comcast.net>
 <201006172144.31869.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201006172144.31869.arnd@arndb.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 09:44:31PM +0200, Arnd Bergmann wrote:
> On Thursday 17 June 2010 21:15:16 Jeff Dike wrote:
> 
> >     The Hayes ESP driver has been removed from the tree:
> >         commit f53a2ade0bb9f2a81f473e6469155172a96b7c38
> >         ("tty: esp: remove broken driver")
> >     so its ioctls aren't needed any more.
> > 
> >     Signed-off-by: Jeff Dike <jdike@linux.intel.com>
> 
> There are still eight architectures that define the same values
> in their private headers, those should probably get removed as well.

Thanks for pointing that out, I'll go remove them as well.

greg k-h
