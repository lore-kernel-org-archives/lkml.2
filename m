Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755134Ab3AHInr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 03:43:47 -0500
Received: from mga09.intel.com ([134.134.136.24]:3133 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754784Ab3AHInp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 03:43:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,430,1355126400"; 
   d="scan'208";a="243337585"
Date: Tue, 8 Jan 2013 00:19:31 -0800
From: Vinod Koul <vinod.koul@intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: linux-next: comment in commit in the slave-dma tree
 (dmaengine: dw_dmac: Enhance device tree support)
Message-ID: <20130108081930.GC19691@intel.com>
References: <20130108093557.8a29d4a04b95702fc59790ff@canb.auug.org.au>
 <20130107224308.GB27477@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130107224308.GB27477@kroah.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 07, 2013 at 02:43:08PM -0800, Greg Kroah-Hartman wrote:
> On Tue, Jan 08, 2013 at 09:35:57AM +1100, Stephen Rothwell wrote:
> > Hi Vinod,
> > 
> > In commit 548860697046 ("dmaengine: dw_dmac: Enhance device tree
> > support") (which was changed since yesterday :-(), an instance of
> > __devinit has been added.  We are in the process of making CONFIG_HOTPLUG
> > always true, and since commit 78d86c213f28 ("init.h: Remove __dev*
> > sections from the kernel") (included in v3.7), __devinit does nothing.
> > Please do not add any more.
> 
> That brings up something I wanted to ask you.
> 
> I'd like to send a patch to Linus to just delete __devinit and friends
> entirely from init.h, but that will break the linux-next tree from
> building in places (like this one, and in a few others.)
> 
> Is that ok?  That should finally get everyone's attention and keep them
> from the cargo-cult programming mode of using these attributes :)
I think if you remove this from linus's tree and since we are in rc2 we can get
it done and remove all other intances from other trees.

--
~Vinod
