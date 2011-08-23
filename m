Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613Ab1HWIXg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 04:23:36 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:56166 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab1HWIXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 04:23:34 -0400
Date: Tue, 23 Aug 2011 09:23:19 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: "Koul, Vinod" <vinod.koul@intel.com>
Cc: Boojin Kim <boojin.kim@samsung.com>, linux-kernel@vger.kernel.org,
        "'Kukjin Kim'" <kgene.kim@samsung.com>
Subject: Re: [PATCH] DMA: PL330: add missing header
Message-ID: <20110823082319.GA19622@n2100.arm.linux.org.uk>
References: <1314079058-24601-1-git-send-email-boojin.kim@samsung.com> <1314081133.22120.19.camel@vkoul-udesk3> <001101cc6164$fe07ce10$fa176a30$%kim@samsung.com> <1314087342.22120.100.camel@vkoul-udesk3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1314087342.22120.100.camel@vkoul-udesk3>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 23, 2011 at 01:45:42PM +0530, Koul, Vinod wrote:
> Russell had fixed compilation of pl330 driver, and was supposed to send
> the fix to Linus as part of his fixes. If thats not done I can send it
> for next -rc

That was for amba-pl08x.c, not pl330.c
