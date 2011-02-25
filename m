Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932475Ab1BYKrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 05:47:31 -0500
Received: from mga11.intel.com ([192.55.52.93]:9807 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932432Ab1BYKra (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 05:47:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,224,1297065600"; 
   d="scan'208";a="891201938"
Date: Fri, 25 Feb 2011 11:47:27 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: Andres Salomon <dilinger@queued.net>, linux-mtd@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/29] t7166xb: mfd_cell is now implicitly available to
 drivers
Message-ID: <20110225104726.GB2693@sortiz-mobl>
References: <1297998456-7615-1-git-send-email-dilinger@queued.net>
 <1297998456-7615-10-git-send-email-dilinger@queued.net>
 <1298624712.2798.21.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298624712.2798.21.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Artem,

On Fri, Feb 25, 2011 at 11:05:12AM +0200, Artem Bityutskiy wrote:
> On Thu, 2011-02-17 at 19:07 -0800, Andres Salomon wrote:
> > No need to explicitly set the cell's platform_data/data_size.
> > 
> > Modify clients to use mfd_get_cell helper function instead of
> > accessing platform_data directly.
> > 
> > Signed-off-by: Andres Salomon <dilinger@queued.net>
> 
> Just to re-confirm, I suggest to merge these MTD changes via Samuel's
> tree, thanks.
Thanks, I'll take them.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
