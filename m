Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757765Ab0G2O5Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 10:57:25 -0400
Received: from cantor.suse.de ([195.135.220.2]:49542 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757730Ab0G2O5X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 10:57:23 -0400
Date: Thu, 29 Jul 2010 07:53:02 -0700
From: Greg KH <gregkh@suse.de>
To: "Savoy, Pavan" <pavan_savoy@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: patch "Staging: ti-st: update ABI and TODO" added to
	staging-next tree
Message-ID: <20100729145302.GB20709@suse.de>
References: <12803306292159@site> <19F8576C6E063C45BE387C64729E7394044EE51EF4@dbde02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19F8576C6E063C45BE387C64729E7394044EE51EF4@dbde02.ent.ti.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 12:49:59PM +0530, Savoy, Pavan wrote:
> Greg,
> 
>  
> > -----Original Message-----
> > From: gregkh@suse.de [mailto:gregkh@suse.de]
> > Sent: Wednesday, July 28, 2010 10:24 AM
> > To: Savoy, Pavan; gregkh@suse.de
> > Subject: patch "Staging: ti-st: update ABI and TODO" added to staging-next tree
> 
> Is it good enough to be moved out of staging?

I don't know, I haven't reviewed it.  Do you want me to do so?  It looks
like you still have a number of things on your TODO list, why not
resolve those first?

> I mean the multi-device thingy would be more or less a nice to have
> feature than being a bug, isn't it?

I don't think Alan thinks so.

> The ease for me would be once out of staging, I can cleanup the
> platform device mess too, since our L-O tree needs to be have some
> patches in the arch/arm/board-XX.c sort of files...

Promises to clean up code after it leaves staging is generally not a
good idea :)

thanks,

greg k-h
