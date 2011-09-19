Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751560Ab1ISHdm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 03:33:42 -0400
Received: from mga03.intel.com ([143.182.124.21]:17872 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750865Ab1ISHdl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 03:33:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,403,1312182000"; 
   d="scan'208";a="18356345"
Date: Mon, 19 Sep 2011 10:34:14 +0300
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: sameo@linux.intel.com
Cc: alan@linux.intel.com, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        feng.tang@intel.com, jacob.jun.pan@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Intel MSIC MFD driver for Medfield platform
Message-ID: <20110919073414.GE23578@intel.com>
References: <cover.1315399396.git.mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1315399396.git.mika.westerberg@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel and x86 maintainers,

Do you have any comments on these patches? Could they be merged into
mainline or do you want me to make some changes?

Thanks.

On Wed, Sep 07, 2011 at 04:06:49PM +0300, Mika Westerberg wrote:
> Hi,
> 
> This series adds support for the Intel MSIC (Mixed Signal IC) chip found on
> Intel Medfield platforms. The MSIC chip embeds audio codec, ADC, GPIOs etc.
> 
> Existing drivers which use plain SCU IPC will continue to work and they can
> be converted to the MSIC register interface later on. Any new drivers for
> devices in the MSIC should use this interface.
> 
> Thanks.
> 
> Alan Cox (1):
>   x86, mrst: Some drivers need to known when an SCU is available
> 
> Mika Westerberg (2):
>   mfd: add Intel MSIC driver
>   x86, mrst: add platform support for MSIC MFD driver
> 
>  arch/x86/include/asm/intel_scu_ipc.h |   22 ++
>  arch/x86/platform/mrst/mrst.c        |  174 +++++++++++-
>  drivers/mfd/Kconfig                  |    9 +
>  drivers/mfd/Makefile                 |    1 +
>  drivers/mfd/intel_msic.c             |  501 ++++++++++++++++++++++++++++++++++
>  include/linux/mfd/intel_msic.h       |  456 +++++++++++++++++++++++++++++++
>  6 files changed, 1149 insertions(+), 14 deletions(-)
>  create mode 100644 drivers/mfd/intel_msic.c
>  create mode 100644 include/linux/mfd/intel_msic.h
> 
> -- 
> 1.7.5.4
