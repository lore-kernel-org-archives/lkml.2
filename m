Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757988Ab2HQV5F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 17:57:05 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33477 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757158Ab2HQV4z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 17:56:55 -0400
Date: Fri, 17 Aug 2012 22:56:47 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Shubhrajyoti D <shubhrajyoti@ti.com>
Cc: spi-devel-general@lists.sourceforge.net, grant.likely@secretlab.ca,
        linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] spi: omap2-mcspi: Remove the call to
 platform_set_drvdata(pdev, NULL)
Message-ID: <20120817215646.GE18871@opensource.wolfsonmicro.com>
References: <1345130370-18815-1-git-send-email-shubhrajyoti@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345130370-18815-1-git-send-email-shubhrajyoti@ti.com>
X-Cookie: Don't read everything you believe.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 16, 2012 at 08:49:30PM +0530, Shubhrajyoti D wrote:
> Remove the call of platform_set_drvdata(pdev, NULL) as they are not
> needed anymore.

Applied, thanks.  These calls were never *needed* people just like to
put them in.
