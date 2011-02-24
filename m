Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756575Ab1BXVYm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 16:24:42 -0500
Received: from void.printf.net ([89.145.121.20]:43208 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932085Ab1BXVYi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 16:24:38 -0500
Date: Thu, 24 Feb 2011 21:24:30 +0000
From: Chris Ball <cjb@laptop.org>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: Philip Rakity <prakity@marvell.com>,
        "Dong, Chuanxiao" <chuanxiao.dong@intel.com>,
        Jae hoon Chung <jh80.chung@gmail.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "arnd@arndb.de" <arnd@arndb.de>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCH 1/1]mmc: set timeout for SDHCI host before sending busy
	cmd
Message-ID: <20110224212429.GB12913@void.printf.net>
References: <20110224111935.GB7169@intel.com> <AANLkTinJEXc_x36Rht=XfYEtjShAYKWRDcsjGFtd=5Tj@mail.gmail.com> <5D8008F58939784290FAB48F5497519835CE59FE81@shsmsx502.ccr.corp.intel.com> <79DD18D4-C79A-4B08-B9E6-050D7EF2FC3D@marvell.com> <20110224201504.GA12913@void.printf.net> <20110224204352.GB9841@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110224204352.GB9841@pengutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, Feb 24, 2011 at 09:43:52PM +0100, Wolfram Sang wrote:
> +1. A full cycle in linux-next might an idea to be on the safe side? That
> would be 2.6.40-material then. Or too slow?

I think it could be okay to merge for .39, but that's mainly because I
don't think we start getting testing with a lot of cards until patches
appear in an -rc1 -- so for something that requires broad testing, I'd
rather merge it for -rc1 with a plan to revert it if we find anything
unexpected.

But I don't have a strong opinion, so if anyone thinks there's a reason
to wait (for example, an existence-proof of a card that misbehaves when
configured with a max timeout value) then I'm happy to do so.

Thanks,

-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
