Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755987Ab3AGWnO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 17:43:14 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:58496 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753662Ab3AGWnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 17:43:12 -0500
Date: Mon, 7 Jan 2013 14:43:08 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Vinod Koul <vinod.koul@intel.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Viresh Kumar <viresh.kumar@linaro.org>
Subject: Re: linux-next: comment in commit in the slave-dma tree (dmaengine:
 dw_dmac: Enhance device tree support)
Message-ID: <20130107224308.GB27477@kroah.com>
References: <20130108093557.8a29d4a04b95702fc59790ff@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130108093557.8a29d4a04b95702fc59790ff@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 08, 2013 at 09:35:57AM +1100, Stephen Rothwell wrote:
> Hi Vinod,
> 
> In commit 548860697046 ("dmaengine: dw_dmac: Enhance device tree
> support") (which was changed since yesterday :-(), an instance of
> __devinit has been added.  We are in the process of making CONFIG_HOTPLUG
> always true, and since commit 78d86c213f28 ("init.h: Remove __dev*
> sections from the kernel") (included in v3.7), __devinit does nothing.
> Please do not add any more.

That brings up something I wanted to ask you.

I'd like to send a patch to Linus to just delete __devinit and friends
entirely from init.h, but that will break the linux-next tree from
building in places (like this one, and in a few others.)

Is that ok?  That should finally get everyone's attention and keep them
from the cargo-cult programming mode of using these attributes :)

thanks,

greg k-h
