Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0EPWBo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 18:01:44 -0400
Received: from mga06.intel.com ([134.134.136.21]:47336 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751239Ab0EPWBn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 18:01:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,242,1272870000"; 
   d="scan'208";a="518395769"
Date: Mon, 17 May 2010 00:02:09 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: fercerpav@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] MFD: pcf50633: Fixes and updates
Message-ID: <20100516220208.GB3236@sortiz.org>
References: <1273623056-1243-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273623056-1243-1-git-send-email-lars@metafoo.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lars-Peter,

On Wed, May 12, 2010 at 02:10:52AM +0200, Lars-Peter Clausen wrote:
> Hi
> 
> This patch series contains fixes and updates for the pcf50633 mfd and adc
> driver.
All 4 patches applied, thanks a lot.

Cheers,
Samuel.


> Lars-Peter Clausen (4):
>   MFD: pcf50633: Fix bitfield logic in interrupt handler
>   MFD: pcf50633-adc: Fix potential race pcf50633_adc_sync_read
>   MFD: pcf50633: Use threaded irq
>   MFD: pcf50633: Move irq related functions to its own file.
> 
>  drivers/mfd/Makefile        |    3 +-
>  drivers/mfd/pcf50633-adc.c  |   39 ++---
>  drivers/mfd/pcf50633-core.c |  344 ++-----------------------------------------
>  drivers/mfd/pcf50633-irq.c  |  318 +++++++++++++++++++++++++++++++++++++++
>  4 files changed, 346 insertions(+), 358 deletions(-)
>  create mode 100644 drivers/mfd/pcf50633-irq.c
> 

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
