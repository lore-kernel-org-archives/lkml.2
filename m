Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab0DWD35 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 23:29:57 -0400
Received: from kroah.org ([198.145.64.141]:42031 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753892Ab0DWD3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 23:29:49 -0400
Date: Thu, 22 Apr 2010 20:16:49 -0700
From: Greg KH <greg@kroah.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] firmware loader: embed device into firmware_priv
	structure
Message-ID: <20100423031649.GB1661@kroah.com>
References: <20100314074330.27035.38765.stgit@localhost.localdomain> <20100314074929.27035.80425.stgit@localhost.localdomain> <20100423000106.GC4414@kroah.com> <20100423001903.GC28213@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100423001903.GC28213@core.coreip.homeip.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 22, 2010 at 05:19:03PM -0700, Dmitry Torokhov wrote:
> On Thu, Apr 22, 2010 at 05:01:06PM -0700, Greg KH wrote:
> > On Sat, Mar 13, 2010 at 11:49:29PM -0800, Dmitry Torokhov wrote:
> > > Both these structures have the same lifetime rules so instead of allocating
> > > and managing them separately embed struct device into struct firmware_priv.
> > > Also make sure to delete sysfs attributes ourselves instead of expecting
> > > sysfs to clean up our mess.
> > 
> > This one didn't apply due to other changes that have happened to the
> > file since you sent this out.  Care to respin it?
> > 
> 
> I'll wait till next next release, see what's there and resping what's
> missing.

Sounds great.

thanks,

greg k-h
