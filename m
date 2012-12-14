Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab2LNV4j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 16:56:39 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49392 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469Ab2LNV4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 16:56:36 -0500
Date: Fri, 14 Dec 2012 13:56:31 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Huang Ying <ying.huang@intel.com>
Cc: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, alan@lxorguk.ukuu.org.uk,
        Bjorn Helgaas <bhelgaas@google.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zhang Yanmin <yanmin.zhang@intel.com>
Subject: Re: [ 02/38] PCI/PM: Fix deadlock when unbinding device if parent in
 D3cold
Message-ID: <20121214215631.GA8076@kroah.com>
References: <20121122003904.262382971@linuxfoundation.org>
 <20121122003904.516735571@linuxfoundation.org>
 <1353638130.4764.4.camel@deadeye.wl.decadent.org.uk>
 <1353640177.28789.21.camel@yhuang-dev>
 <1353656862.28789.57.camel@yhuang-dev>
 <20121130020104.GJ13478@kroah.com>
 <1354244049.29553.97.camel@yhuang-dev>
 <1355213572.7216.140.camel@yhuang-dev>
 <20121211180812.GC25714@kroah.com>
 <1355468932.24876.153.camel@yhuang-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355468932.24876.153.camel@yhuang-dev>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 14, 2012 at 03:08:52PM +0800, Huang Ying wrote:
> On Tue, 2012-12-11 at 10:08 -0800, Greg Kroah-Hartman wrote:
> > On Tue, Dec 11, 2012 at 04:12:52PM +0800, Huang Ying wrote:
> [snip]
> > > Which tree should I base the patch on?
> > 
> > 3.6.10 would be great.
> 
> Here is the patch for 3.6.10.

Thanks, now applied.

greg k-h
