Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751927Ab1IVQ2X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 12:28:23 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43245 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab1IVQ2W (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 12:28:22 -0400
Date: Thu, 22 Sep 2011 09:28:13 -0700
From: Greg KH <gregkh@suse.de>
To: "Weil, Oren jer" <oren.jer.weil@intel.com>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Winkler, Tomas" <tomas.winkler@intel.com>,
        "Noam, Amir" <amir.noam@intel.com>
Subject: Re: MEI Driver - Moving to Main tree
Message-ID: <20110922162813.GA31177@suse.de>
References: <F28B59AD52D84B479DCA4698244753350671AD513A@hasmsx503.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F28B59AD52D84B479DCA4698244753350671AD513A@hasmsx503.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 22, 2011 at 04:43:45PM +0300, Weil, Oren jer wrote:
> Hello Greg.
> 
> Yesterday I have submitted the last patch of our effort to cleanup, order and stabilize the MEI driver.
> As we see it the driver is stable and ready to move to main tree.
> The last task that was left in the TODO (splitting of the driver timer) is task that is not related stability of the driver, 
> it is part of preparing the driver infrastructure to better support newer HW in the future.
> 
> I would like to move the driver to main tree, what do you think?

The user/kernel interface to this driver is quite confusing to me.
Where is it documented as to how this all works, and where are the
userspace tools that integrate into this?

You seem to use both sysfs and ioctls, why the mix?

And what happened to the in-kernel api that you were going to do, why
did you remove that from the TODO file?

thanks,

greg k-h
