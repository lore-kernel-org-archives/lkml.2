Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757048Ab1BAODz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 09:03:55 -0500
Received: from mga14.intel.com ([143.182.124.37]:34134 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756940Ab1BAODy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:03:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,410,1291622400"; 
   d="scan'208";a="382655379"
Date: Tue, 1 Feb 2011 15:03:50 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sascha Hauer <s.hauer@pengutronix.de>, liu.y.victor@gmail.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        B02280@freescale.com
Subject: Re: [PATCH 3/9] Add a mfd IPUv3 driver
Message-ID: <20110201140349.GA11583@sortiz-mobl>
References: <1292842127-21406-1-git-send-email-s.hauer@pengutronix.de>
 <1292842127-21406-4-git-send-email-s.hauer@pengutronix.de>
 <20110201105127.GA10128@sortiz-mobl>
 <20110201105909.GS9041@pengutronix.de>
 <20110201114453.GC10128@sortiz-mobl>
 <20110201115125.GE31216@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110201115125.GE31216@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 11:51:25AM +0000, Russell King - ARM Linux wrote:
> On Tue, Feb 01, 2011 at 12:44:54PM +0100, Samuel Ortiz wrote:
> > Ok, so would moving it do drivers/video/ make sense ?
> 
> Isn't that for framebuffer drivers?
Mostly yes, but there are some display controller drivers there as well. See
drivers/video/omap*/.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
