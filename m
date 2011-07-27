Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751527Ab1G0Jva (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:51:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:2985 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750828Ab1G0Jv2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:51:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,275,1309762800"; 
   d="scan'208";a="32795360"
Date: Wed, 27 Jul 2011 11:52:40 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH] mfd: Acknowlege all WM831x IRQs before we handle them
Message-ID: <20110727095240.GA26275@sortiz-mobl>
References: <1311177913-4560-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311177913-4560-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Wed, Jul 20, 2011 at 05:05:13PM +0100, Mark Brown wrote:
> Ensure that we never have a window where we've handled an interrupt (and
> therefore need to be notified of new events) but haven't yet told the
> interrupt controller that this is the case (so any new events will be
> discarded).
Thanks, patch applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
