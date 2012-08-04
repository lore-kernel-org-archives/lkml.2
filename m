Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab2HDNFH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 09:05:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35757 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752725Ab2HDNE4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 09:04:56 -0400
Date: Sat, 4 Aug 2012 12:06:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, grant.likely@secretlab.ca,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: omap2-mcspi: Fix the error handling in probe
Message-ID: <20120804110654.GD10523@opensource.wolfsonmicro.com>
References: <1343905885-31549-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343905885-31549-1-git-send-email-shubhrajyoti@ti.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 04:41:25PM +0530, Shubhrajyoti D wrote:
> The kfree() is taken care of by the spi core (spi_master_release() function)
> that is called once the last reference to the underlying struct device has
> been released. So the driver need not call kfree.

Applied, thanks.
