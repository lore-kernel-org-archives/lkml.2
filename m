Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756661Ab0FYSZY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 14:25:24 -0400
Received: from kroah.org ([198.145.64.141]:43714 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750777Ab0FYSZX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 14:25:23 -0400
Date: Fri, 25 Jun 2010 11:22:24 -0700
From: Greg KH <greg@kroah.com>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
       Johannes Berg <johannes.berg@intel.com>, Dmitry Torokhov <dtor@mail.ru>,
       Marcel Holtmann <marcel@holtmann.org>, Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH] firmware: Update hotplug script, remove sysfs files
Message-ID: <20100625182224.GA14459@kroah.com>
References: <20100625085511.30949.41045.sendpatchset@t400s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100625085511.30949.41045.sendpatchset@t400s>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 25, 2010 at 05:55:11PM +0900, Magnus Damm wrote:
> From: Magnus Damm <damm@opensource.se>
> 
> Update the in-kernel hotplug example script to work
> properly with recent kernels. Without this fix the
> script may load the firmware twice - both at "add"
> and "remove" time.
> 
> The second load only triggers in the case when multiple
> firmware images are used. A good example is the b43
> driver which does not work properly without this fix.
> 
> While at it, make sure sysfs files are removed.

Hm, the documentation update applied, but this second part didn't.  Care
to redo it against the linux-next tree and resend it as a separate
patch?  I've split this up and applied the documentation part now, so
you don't have to redo that.

thanks,

greg k-h
