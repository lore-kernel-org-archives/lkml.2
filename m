Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757140Ab0DGImm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 04:42:42 -0400
Received: from mga09.intel.com ([134.134.136.24]:47425 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab0DGImg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 04:42:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,377,1267430400"; 
   d="scan'208";a="507039100"
Date: Wed, 7 Apr 2010 10:43:06 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Todd Fischer <todd.fischer@ridgerun.com>
Cc: linux-kernel@vger.kernel.org,
       davinci-linux-open-source@linux.davincidsp.com, lrg@slimlogic.co.uk,
       broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 0/4]-V3 TPS6507x MFD driver
Message-ID: <20100407084305.GA2962@sortiz.org>
References: <1270520639-20516-1-git-send-email-todd.fischer@ridgerun.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270520639-20516-1-git-send-email-todd.fischer@ridgerun.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Todd,

On Mon, Apr 05, 2010 at 08:23:55PM -0600, Todd Fischer wrote:
> 
> This is the third posting of the TPS6507x driver set.  I have
> resolved the concurrent access issue identified by Mark Brown.
> Instead of using a mutex, I used the i2c_transfer() as done in
> the similar routine in the wm8400-core.c file.
> 
> The TPS6507x family of Texas Instruments power management ICs (pmic) are
> multi-function chips that include voltage regulation and touch screen
> controller capabilities.  This patch set adds a TPS6507x multi-function
> device driver and change the TPS6507x regulator driver to use the
> TPS6507x MFD driver instead of interacting with the chip directly.  The
> changes are needed before a touch screen driver can be added.
> 
> The patch set applies cleanly to the MFD repository:
> git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git  If the
> MFD and voltage regulator maintainer would prefer I post patches for a
> different repository, please let me know.
All 4 patches applied to my for-next branch.
Some nit picking advices for your future patches:
- Include the Signed-off-by and Acked-by you collect along the review cycles.
- Have shorter patch subject, they typically are less than 80 chars.
- Describe the changes when moving from patchset vN to patchset vN+1. Also we
prefer "[PATCH vN]" to "[PATCH]-vN", it makes our life easier when applying
your patches.

Thanks a lot for your work.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
