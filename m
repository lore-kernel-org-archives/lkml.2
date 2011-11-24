Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755612Ab1KXKTc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 05:19:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44067 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753852Ab1KXKTb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 05:19:31 -0500
Date: Thu, 24 Nov 2011 10:19:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Wan ZongShun <mcuos.com@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "Jean Delvare (PC drivers, core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Grant Likely <grant.likely@secretlab.ca>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] ARM: add subname parameter to mfp_set_groupg callers
Message-ID: <20111124101928.GA8470@opensource.wolfsonmicro.com>
References: <1322103983.16201.7.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1322103983.16201.7.camel@phoenix>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 24, 2011 at 11:06:23AM +0800, Axel Lin wrote:
> commit 798681bf "ARM: 7158/1: add new MFP implement for NUC900"
> adds subname parameter for mfp_set_groupg.
> 
> Thus add subname parameter to the callers.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
