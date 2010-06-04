Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751815Ab0FDVDV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jun 2010 17:03:21 -0400
Received: from kroah.org ([198.145.64.141]:42843 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750785Ab0FDVDU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jun 2010 17:03:20 -0400
Date: Fri, 4 Jun 2010 14:03:13 -0700
From: Greg KH <greg@kroah.com>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Linus Torvalds <torvalds@osdl.org>, Andrew Morton <akpm@osdl.org>,
       linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [GIT PATCH] STAGING fixes and new drivers for 2.6.35-git
Message-ID: <20100604210313.GB7912@kroah.com>
References: <20100604204455.GD19761@kroah.com>
 <AANLkTilwzoUlastS0M9OMKuWgwmDE3VXdf2LCJxf50dV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTilwzoUlastS0M9OMKuWgwmDE3VXdf2LCJxf50dV@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 04, 2010 at 04:48:23PM -0400, Mike Frysinger wrote:
> On Fri, Jun 4, 2010 at 16:44, Greg KH wrote:
> > apatard@mandriva.com (1):
> >      staging: Add framebuffer driver for XGI chipsets
> 
> does the staging tree not require properly formatted git patches ?

"properly formatted" how?

Yes, there are coding style issues in there, that's one of the reasons
it's in the staging tree :)

Or are you referring to something else?

thanks,

greg k-h
