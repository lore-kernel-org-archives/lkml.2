Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755219Ab0LOUKr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 15:10:47 -0500
Received: from kroah.org ([198.145.64.141]:59330 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754849Ab0LOUKp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:10:45 -0500
Date: Wed, 15 Dec 2010 12:10:29 -0800
From: Greg KH <greg@kroah.com>
To: Sutharsan <srmt@cypress.com>
Cc: odc@cypress.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adding gpmc configuration functions, west bridge
 related
Message-ID: <20101215201029.GA32710@kroah.com>
References: <1292443046.1771.47.camel@sutharsan-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292443046.1771.47.camel@sutharsan-laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 11:57:26AM -0800, Sutharsan wrote:
> 
> This patch adds and exports gpmc configuration functions. 
> 'gpmc' configuration functions will be used by westbridge device controller driver.

So this driver isn't submitted yet?

Then I would hold off on this until that time when it is needed by that
other driver.

Also, any USB related patches should be copied to the
linux-usb@vger.kernel.org list, and any ARM patches to that related
list, so next time cc: 2 more lists please.

thanks,

greg k-h
