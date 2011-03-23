Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab1CWSrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 14:47:07 -0400
Received: from kroah.org ([198.145.64.141]:35348 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932150Ab1CWSrF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 14:47:05 -0400
Date: Wed, 23 Mar 2011 11:44:21 -0700
From: Greg KH <greg@kroah.com>
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au
Subject: Re: [PATCH 1/3] Add a kstrtobool function matching semantics of
 existing in kernel equivalents.
Message-ID: <20110323184421.GA21728@kroah.com>
References: <1300887554-19031-1-git-send-email-jic23@cam.ac.uk>
 <1300887554-19031-2-git-send-email-jic23@cam.ac.uk>
 <AANLkTimeEKjVwwYi+twb0oeoFK-33LMx5aQBZEnPodne@mail.gmail.com>
 <20110323160120.GA8770@kroah.com>
 <4D8A1CB7.4090505@cam.ac.uk>
 <20110323162351.GB9367@kroah.com>
 <4D8A21D4.6070102@cam.ac.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D8A21D4.6070102@cam.ac.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 04:37:40PM +0000, Jonathan Cameron wrote:
> > Ok, perhaps the name might need to be changed a bit, but the idea is
> > still good to have.  Please try again.
> > 
> Any thoughts on what naming would work?  Nothing immediately comes to mind
> which is why I ended up pinching the kstrto* naming...
> 
> reallysloppy_strtobool?
> guessintent_strtobool?

usr_strtobool?  I don't care :)

> or the old classic underscore prefix to 'encourage' people to check what it does
> before using it
> 
> __strtobool?

Ick, no, that implies that no one outside of this file should call it.
Or it should be called with locks held or some such "special" thing.
Don't do that...

thanks,

greg k-h
