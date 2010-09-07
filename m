Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800Ab0IGGmL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 02:42:11 -0400
Received: from kroah.org ([198.145.64.141]:42399 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752216Ab0IGGmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 02:42:05 -0400
Date: Mon, 6 Sep 2010 23:14:20 -0700
From: Greg KH <greg@kroah.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
        Arnaud Patard <apatard@mandriva.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: xgifb: Removes unnecessary log
Message-ID: <20100907061420.GA2889@kroah.com>
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

Note, you need to fix up how your patches are generated.  [1/1] and then
[2/2] and then [3/3] would cause me to belive that I'm missing some
patches you would have sent out (1/2, 1/3, and 2/3).  Just use git
format-patch to generate them if you have a problem with them.

> The first version of this patch casted XGIFB_GET_INFO to unsigned long, but Greg suggest that I should use %p instead and that the whole message is just looney.

Please wrap your lines at 72 characters.

thanks,

greg k-h
