Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751809Ab2DTFRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 01:17:11 -0400
Received: from ipmail06.adl6.internode.on.net ([150.101.137.145]:57841 "EHLO
	ipmail06.adl6.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751595Ab2DTFRG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 01:17:06 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ArYLAJHwkE95LAIE/2dsb2JhbABDsDEBgQuBCIIJAQEFOhwjEAgDGC4UJQMhE4gODLpHBBOMeIJ5YwSVcJA9gnk
Date: Fri, 20 Apr 2012 14:59:32 +1000
From: Dave Chinner <david@fromorbit.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Shyju PV <shyju.pv@huawei.com>, linux-kernel@vger.kernel.org
Subject: Re: bnx2 driver loading error : Can't load firmware file
 "bnx2/bnx2-mips-09-6.2.1b.fw
Message-ID: <20120420045932.GE9541@dastard>
References: <A49C75C4810A4DD7AAED96B4A5F1A2D4@china.huawei.com>
 <20120420030837.GA17471@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120420030837.GA17471@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 08:08:37PM -0700, Greg KH wrote:
> On Fri, Apr 20, 2012 at 08:29:25AM +0530, Shyju PV wrote:
> >   
> > Hi
> > Logged a bug on 3rd april on 3.4-rc1 kernel. 
> > Bug ID : 43036
> > Short descreption : bnx2 driver loading error : Can't load firmware file
> > "bnx2/bnx2-mips-09-6.2.1b.fw Bugzila url :
> > https://bugzilla.kernel.org/show_bug.cgi?id=43036
> > The status of the bug is "new" in the bugzila.
> > Please update.
> 
> Do you have that firmware file on your machine?

It's the silly CONFIG_FIRMWARE_IN_KERNEL/external firwmware tree
problem again:

https://lkml.org/lkml/2012/4/18/142

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
