Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab1KVCWB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 21:22:01 -0500
Received: from mga14.intel.com ([143.182.124.37]:48635 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753497Ab1KVCV7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 21:21:59 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,551,1315206000"; 
   d="scan'208";a="77789882"
Date: Tue, 22 Nov 2011 10:21:57 +0800
From: Wu Fengguang <fengguang.wu@intel.com>
To: Chris Mason <chris.mason@oracle.com>, linux-fsdevel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] btrfs: lower the dirty balance poll interval
Message-ID: <20111122022157.GB20982@localhost>
References: <20111117122403.GA32363@localhost>
 <20111121203614.GE28259@shiny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121203614.GE28259@shiny>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 04:36:14AM +0800, Chris Mason wrote:
> On Thu, Nov 17, 2011 at 08:24:03PM +0800, Wu Fengguang wrote:
> > Tests show that the original large intervals can easily make the dirty
> > limit exceeded on 100 concurrent dd's. So adapt to as large as the
> > next check point selected by the dirty throttling algorithm.
> 
> Thanks Wu, were you planning on pushing this through your tree or should
> I take it?

Will you take it please?

Thanks,
Fengguang
