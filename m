Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0IGGmR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 02:42:17 -0400
Received: from kroah.org ([198.145.64.141]:42413 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754859Ab0IGGmN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 02:42:13 -0400
Date: Mon, 6 Sep 2010 23:16:46 -0700
From: Greg KH <greg@kroah.com>
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Bill Pemberton <wfp5p@virginia.edu>,
        Arnaud Patard <apatard@mandriva.com>,
        Randy Dunlap <randy.dunlap@oracle.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] staging: xgifb: Removes compilation conditionals
Message-ID: <20100907061646.GA2997@kroah.com>
References: <1283837543.6302.8.camel@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283837543.6302.8.camel@lenovo>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 01:32:23AM -0400, Javier Martinez Canillas wrote:
> This patch fixes a compilation warning in today linux-next. 
> 
> The first version of this patch introduced a compilation conditional but Greg pointed me that instead of adding more compilation conditional, 
> the code needs to be fixed to not need more of them.
> 
> So this patch removes some compilation conditionals to eliminate the compilation warning.

Again, this one fails to apply :(

thanks,

greg k-h
