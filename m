Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab1BRAB4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 19:01:56 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50182 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752091Ab1BRABw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 19:01:52 -0500
Date: Fri, 18 Feb 2011 00:01:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Greg KH <greg@kroah.com>
Cc: Charles Manning <manningc2@actrix.gen.nz>,
        Ryan Mallon <ryan@bluewatersys.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Message-ID: <20110218000150.GA27668@opensource.wolfsonmicro.com>
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com> <201102171531.03924.manningc2@actrix.gen.nz> <4D5C8D62.4060809@bluewatersys.com> <201102171649.57457.manningc2@actrix.gen.nz> <20110217234154.GA1474@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110217234154.GA1474@kroah.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 03:41:54PM -0800, Greg KH wrote:
> On Thu, Feb 17, 2011 at 04:49:57PM +1300, Charles Manning wrote:

> > Stripping out the tracing is easy enough but pointless if people (ie those 
> > actually using yaffs) really want it. Same for the proc interface (though 
> > that could be moved to sysfs).

> Use debugfs please, if it's debugging stuff.  If it's "real" stuff, then
> yes, it should be in sysfs, you already have a place for it in /sys/fs/
> to use.  Just abide by the sysfs rules and you will be fine.

For the proc stuff - for tracing stuff then tracepoints are likely to be
a good option if it's useful to people.
