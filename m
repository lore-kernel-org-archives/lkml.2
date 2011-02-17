Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359Ab1BQXnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 18:43:04 -0500
Received: from kroah.org ([198.145.64.141]:59845 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809Ab1BQXnC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 18:43:02 -0500
Date: Thu, 17 Feb 2011 15:41:54 -0800
From: Greg KH <greg@kroah.com>
To: Charles Manning <manningc2@actrix.gen.nz>
Cc: Ryan Mallon <ryan@bluewatersys.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 0/10] Add yaffs2 file system:  Fifth patchset
Message-ID: <20110217234154.GA1474@kroah.com>
References: <1297221968-6747-1-git-send-email-cdhmanning@gmail.com>
 <201102171531.03924.manningc2@actrix.gen.nz>
 <4D5C8D62.4060809@bluewatersys.com>
 <201102171649.57457.manningc2@actrix.gen.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102171649.57457.manningc2@actrix.gen.nz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 04:49:57PM +1300, Charles Manning wrote:
> Stripping out the tracing is easy enough but pointless if people (ie those 
> actually using yaffs) really want it. Same for the proc interface (though 
> that could be moved to sysfs).

Use debugfs please, if it's debugging stuff.  If it's "real" stuff, then
yes, it should be in sysfs, you already have a place for it in /sys/fs/
to use.  Just abide by the sysfs rules and you will be fine.

thanks,

greg k-h
