Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab0K0Ahl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 19:37:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:49701 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625Ab0K0Ahl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 19:37:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,263,1288594800"; 
   d="scan'208";a="630642862"
Date: Sat, 27 Nov 2010 01:37:38 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 1/2] mfd: Provide pm_runtime_no_callbacks flag in cell
 data
Message-ID: <20101127003737.GB4777@sortiz-mobl>
References: <1290791975-21160-1-git-send-email-broonie@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1290791975-21160-1-git-send-email-broonie@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

On Fri, Nov 26, 2010 at 05:19:34PM +0000, Mark Brown wrote:
> Allow MFD cells to have pm_runtime_no_callbacks() called on them during
> registration. This causes the runtime PM framework to ignore them,
> allowing use of runtime PM to suspend the device as a whole even if
> not all drivers for the MFD can usefully implement runtime PM. For
> example, RTCs are likely to run continuously regardless of the power
> state of the system.
Makes sense, both patches applied.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
