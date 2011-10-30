Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750841Ab1J3XAc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 19:00:32 -0400
Received: from mga03.intel.com ([143.182.124.21]:45040 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740Ab1J3XAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 19:00:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,427,1315206000"; 
   d="scan'208";a="68612283"
Date: Mon, 31 Oct 2011 00:04:18 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: linux-next: Tree for Oct 25 (mfd/ab8500)
Message-ID: <20111030230418.GA3846@sortiz-mobl>
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au>
 <4EA850C1.4060405@xenotime.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA850C1.4060405@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Randy,

On Wed, Oct 26, 2011 at 11:26:09AM -0700, Randy Dunlap wrote:
> On 10/25/11 02:36, Stephen Rothwell wrote:
> > Hi all,
> 
> 
> drivers/mfd/ab8500-core.c:881:7: error: 'AB8500_CUT3P3' undeclared
Thanks for the report. This is now fixed.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
