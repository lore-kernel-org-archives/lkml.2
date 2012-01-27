Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755221Ab2A0WZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 17:25:18 -0500
Received: from cantor2.suse.de ([195.135.220.15]:35566 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754620Ab2A0WZQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 17:25:16 -0500
Date: Fri, 27 Jan 2012 14:18:46 -0800
From: Greg KH <gregkh@suse.de>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] zcache: fix deadlock condition
Message-ID: <20120127221846.GA32654@suse.de>
References: <356ccc29-31af-4274-b372-c8fd1a9b10cb@default>
 <20120127203928.GA17285@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120127203928.GA17285@phenom.dumpdata.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 27, 2012 at 03:39:28PM -0500, Konrad Rzeszutek Wilk wrote:
> On Wed, Jan 25, 2012 at 02:32:51PM -0800, Dan Magenheimer wrote:
> > I discovered this deadlock condition awhile ago working on RAMster
> > but it affects zcache as well.  The list spinlock must be
> > locked prior to the page spinlock and released after.  As
> > a result, the page copy must also be done while the locks are held.
> > 
> > Applies to 3.2.  Konrad, please push (via GregKH?)...
> > this is definitely a bug fix so need not be pushed during
> > a -rc0 window.
> 
> Looks good to me. Greg, could you apply the patch to your tree
> please? [Or would you rather I sent an GIT pull?]

I will queue it up, thanks.

greg k-h
