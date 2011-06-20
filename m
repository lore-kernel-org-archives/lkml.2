Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab1FTNqt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 09:46:49 -0400
Received: from mga14.intel.com ([143.182.124.37]:7593 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754581Ab1FTNqq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 09:46:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,394,1304319600"; 
   d="scan'208";a="15568564"
Date: Mon, 20 Jun 2011 15:46:52 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Margarita Olaya <magi@slimlogic.co.uk>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        grant.likely@secretlab.ca, "Girdwood, Liam" <lrg@ti.com>
Subject: Re: [PATCHv5 0/4]Initial support for TPS65912 PMIC
Message-ID: <20110620134652.GL22420@sortiz-mobl>
References: <BANLkTikye+vb1WJ08rup23=APxuOENK+Tw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikye+vb1WJ08rup23=APxuOENK+Tw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Margarita,

On Thu, Jun 09, 2011 at 02:49:47PM -0500, Margarita Olaya wrote:
> Hi,
> 
> This is the initial version of the TPS65912 PMIC, a power management IC
> for multimedia products.
> 
> The tps65912 consists of 4 DCDCs and 10 LDOs, that are able to supply
> voltage to main processor and other components. The chip includes a
> GPIO module.
All 4 patches applied, after some trivial whitespace fixing. Thanks a lot.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
