Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933992Ab0HESFJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 14:05:09 -0400
Received: from kroah.org ([198.145.64.141]:59122 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758569Ab0HESFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 14:05:06 -0400
Date: Thu, 5 Aug 2010 11:03:11 -0700
From: Greg KH <greg@kroah.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] driver core: device_rename's new_name can be const
Message-ID: <20100805180311.GA13019@kroah.com>
References: <1281022698.4058.9.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281022698.4058.9.camel@jlt3.sipsolutions.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 05, 2010 at 05:38:18PM +0200, Johannes Berg wrote:
> The new_name argument to device_rename() can be
> const as kobject_rename's new_name argument is.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
> I have a patch that I would like to push into the wireless tree for .37
> that relies on this to not generate a compiler warning, it would be nice
> if this could get into .36 but I don't know if that's possible now.

Yes, it's simple enough for me to get into this merge.

thanks,

greg k-h
