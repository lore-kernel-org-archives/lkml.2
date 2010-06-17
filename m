Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760455Ab0FQR2e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 13:28:34 -0400
Received: from kroah.org ([198.145.64.141]:44223 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab0FQR2d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 13:28:33 -0400
Date: Thu, 17 Jun 2010 10:28:28 -0700
From: Greg KH <greg@kroah.com>
To: Jeff Dike <jdike@addtoit.com>
Cc: Alan Cox <alan@linux.intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove Hayes ESP ioctls
Message-ID: <20100617172828.GA24362@kroah.com>
References: <20100617160045.GA13743@c-98-229-117-200.hsd1.ma.comcast.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100617160045.GA13743@c-98-229-117-200.hsd1.ma.comcast.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 12:00:45PM -0400, Jeff Dike wrote:
> commit e6b14f5bc9803589241bc2aae1565fa0c5bd0ce1
> Author: Jeff Dike <jdike@linux.intel.com>
> Date:   Thu Jun 17 11:54:24 2010 -0400
> 
>     Remove Hayes ESP ioctls
>     
>     The Hayes ESP driver has been removed from the tree:
>         commit f53a2ade0bb9f2a81f473e6469155172a96b7c38
>         ("tty: esp: remove broken driver")
>     so its ioctls aren't needed any more.
> 

You forgot to put a "Signed-off-by:" line in here.

Care to add it, and resend it to me?

thanks,

greg k-h
