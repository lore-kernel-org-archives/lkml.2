Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab1BRAgq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:36:46 -0500
Received: from kroah.org ([198.145.64.141]:56808 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752904Ab1BRAgi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:36:38 -0500
Date: Thu, 17 Feb 2011 16:33:53 -0800
From: Greg KH <greg@kroah.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Charles Manning <manningc2@actrix.gen.nz>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Message-ID: <20110218003353.GA25386@kroah.com>
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com>
 <201102171531.03924.manningc2@actrix.gen.nz>
 <4D5C8D62.4060809@bluewatersys.com>
 <201102171649.57457.manningc2@actrix.gen.nz>
 <20110217234154.GA1474@kroah.com>
 <20110218000150.GA27668@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110218000150.GA27668@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 18, 2011 at 12:01:50AM +0000, Mark Brown wrote:
> On Thu, Feb 17, 2011 at 03:41:54PM -0800, Greg KH wrote:
> > On Thu, Feb 17, 2011 at 04:49:57PM +1300, Charles Manning wrote:
> 
> > > Stripping out the tracing is easy enough but pointless if people (ie those 
> > > actually using yaffs) really want it. Same for the proc interface (though 
> > > that could be moved to sysfs).
> 
> > Use debugfs please, if it's debugging stuff.  If it's "real" stuff, then
> > yes, it should be in sysfs, you already have a place for it in /sys/fs/
> > to use.  Just abide by the sysfs rules and you will be fine.
> 
> For the proc stuff - for tracing stuff then tracepoints are likely to be
> a good option if it's useful to people.

Then use the in-kernel tracing functionality, don't roll your own.  And
that is not in /proc, so it should be there for this filesystem either.

thanks,

greg k-h
