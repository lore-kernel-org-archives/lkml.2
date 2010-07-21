Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab0GUTTY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 15:19:24 -0400
Received: from kroah.org ([198.145.64.141]:35236 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758830Ab0GUTTP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 15:19:15 -0400
Date: Wed, 21 Jul 2010 12:17:57 -0700
From: Greg KH <greg@kroah.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Subject: Re: [PATCHv3 1/2] usb: gadget: storage: strict coversion of 'ro'
 parameter
Message-ID: <20100721191757.GB28893@kroah.com>
References: <op.vft7mxqm7p4s8u@pikus>
 <1279184841-15097-1-git-send-email-ext-andriy.shevchenko@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1279184841-15097-1-git-send-email-ext-andriy.shevchenko@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 15, 2010 at 12:07:20PM +0300, Andy Shevchenko wrote:
> Bring a strict way to get the 'ro' parameter from the user.
> The idea was discussed in LKML [1].
> 
> [1] http://lkml.org/lkml/2010/7/13/143

Care to provide a bit more information as to why this is being changed
instead of just a link to an old email?

thanks,

greg k-h
