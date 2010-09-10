Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755238Ab0IJU35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 16:29:57 -0400
Received: from kroah.org ([198.145.64.141]:50600 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751453Ab0IJU3y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 16:29:54 -0400
Date: Fri, 10 Sep 2010 13:29:43 -0700
From: Greg KH <greg@kroah.com>
To: Adrian Hunter <adrian.hunter@nokia.com>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Shevchenko Andriy (EXT-Teleca/Helsinki)" 
	<ext-andriy.shevchenko@nokia.com>
Subject: Re: [PATCH] mmc_test: move files from sysfs to debugfs
Message-ID: <20100910202943.GB9862@kroah.com>
References: <1284102650-15044-1-git-send-email-ext-andriy.shevchenko@nokia.com>
 <4C89DC01.6000601@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C89DC01.6000601@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 10:19:29AM +0300, Adrian Hunter wrote:
> Andy Shevchenko wrote:
> >As proposed by Greg the more logically is to keep files for mmc_test driver
> >under debugfs.
> 
> What happens if debugfs is not enabled in config?  Should there be
> some kind of dependency there?  At least an error message would be
> good - see below.

That would be good, but note that all major distros now enable it, so
it's less and less of an issue these days.

thanks,

greg k-h
