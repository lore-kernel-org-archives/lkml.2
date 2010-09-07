Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0IGGmZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 02:42:25 -0400
Received: from kroah.org ([198.145.64.141]:42406 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752931Ab0IGGmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 02:42:09 -0400
Date: Mon, 6 Sep 2010 23:16:14 -0700
From: Greg KH <greg@kroah.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>,
        "Prashant P. Shah" <pshah.mumbai@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
        Arnaud Patard <apatard@mandriva.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: xgifb: Removes unnecessary log
Message-ID: <20100907061614.GA2925@kroah.com>
References: <1283837309.6302.4.camel@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283837309.6302.4.camel@lenovo>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 01:28:29AM -0400, Javier Martinez Canillas wrote:
> This patch fixes a compile warning in today linux-next.
> 
> The first version of this patch casted XGIFB_GET_INFO to unsigned
> long, but Greg suggest that I should use %p instead and that the whole
> message is just looney.
> 
> So this patch removes the unnecessary log.

Unfortunatly it doesn't apply as you and Prashant seem to like to modify
the same file on the same day.  Prashant's patch is now in my tree, so
you need to redo this one.  I suggest you two get together and
coordinate this so I can stop rejecting every other patch from both of
you :)

thanks,

greg k-h
