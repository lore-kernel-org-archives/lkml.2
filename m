Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751997Ab2AFGLW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 01:11:22 -0500
Received: from mga03.intel.com ([143.182.124.21]:46892 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab2AFGLU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 01:11:20 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="92982402"
Subject: Re: [PATCH 0/2] dma: shdma: clear buffers on reset
From: Vinod Koul <vinod.koul@intel.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Magnus Damm <magnus.damm@gmail.com>
In-Reply-To: <Pine.LNX.4.64.1201041528570.30506@axis700.grange>
References: <Pine.LNX.4.64.1201041528570.30506@axis700.grange>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 06 Jan 2012 11:41:37 +0530
Message-ID: <1325830297.1540.97.camel@vkoul-udesk3>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-04 at 15:34 +0100, Guennadi Liakhovetski wrote:
> This patch set fixes a runtime PM problem on shdma, whereby it fails to 
> recover after the power domain has been switched off.
> 
Both applied, thanks

-- 
~Vinod

