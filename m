Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809Ab2JIDvJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 23:51:09 -0400
Received: from mga01.intel.com ([192.55.52.88]:26047 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753163Ab2JIDvI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 23:51:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,557,1344236400"; 
   d="scan'208";a="231529136"
Subject: Re: [GIT PULL] MMC updates for 3.7-rc1
From: Vinod Koul <vinod.koul@linux.intel.com>
To: Chris Ball <cjb@laptop.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
In-Reply-To: <87pq4sco5i.fsf@octavius.laptop.org>
References: <87a9vxdsia.fsf@octavius.laptop.org>
	 <87pq4sco5i.fsf@octavius.laptop.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Oct 2012 09:12:12 +0530
Message-ID: <1349754132.1648.5253.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-08 at 23:36 -0400, Chris Ball wrote:
> Hi Linus,
> 
> On Mon, Oct 08 2012, Chris Ball wrote:
> > Please pull from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-merge-for-3.7-rc1
> >
> > to receive the MMC merge for 3.7.  There are currently two conflicts
> > due to header renames for the ARM single zImage work; they should be
> > resolved by taking the changes already in your tree.  Thanks.
> 
> Sorry, the merge isn't so one-sided -- here's my resolution for you to
> compare with:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/cjb/mmc.git tags/mmc-merge-for-3.7-rc1-merged
> 
> davinci_mmc.c now uses <linux/edma.h> which is provided by a commit
> in the slave-dmaengine tree, which hasn't sent in a pull request yet.
> Vinod, please can you do that soon?
...just finished sending the request.
> 
> Let me know if I should do anything else.  Thanks,
> 
> - Chris.


-- 
~Vinod

