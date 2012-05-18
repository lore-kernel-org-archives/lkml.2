Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967901Ab2ERJnv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 05:43:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:57097 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S967112Ab2ERJnu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 05:43:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="145503981"
Date: Fri, 18 May 2012 11:53:45 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Grant Likely <grant.likely@secretlab.ca>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] mfd: tps65910-irq: Add devicetree init support
Message-ID: <20120518095345.GE12015@sortiz-mobl>
References: <1337036142-10899-1-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337036142-10899-1-git-send-email-rklein@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rhyland,

On Mon, May 14, 2012 at 06:55:42PM -0400, Rhyland Klein wrote:
> This change changes the tps65910-irq code to use irqdomain, and support
> initialization from devicetree. This assumes that the irq_base in the platform
> data is -1 if devicetree is used.
> 
> Signed-off-by: Rhyland Klein <rklein@nvidia.com>
Patch applied, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
