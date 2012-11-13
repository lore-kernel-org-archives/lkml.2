Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab2KMS7I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 13:59:08 -0500
Received: from mga09.intel.com ([134.134.136.24]:43285 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755595Ab2KMS7F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 13:59:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,768,1344236400"; 
   d="scan'208";a="219116110"
Date: Tue, 13 Nov 2012 19:59:02 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Tero Kristo <t-kristo@ti.com>, linux-kernel@vger.kernel.org,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH] MFD: twl-core: Fix chip ID for the twl6030-pwm module
Message-ID: <20121113185902.GO27828@sortiz-mobl>
References: <1351695277-8629-1-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351695277-8629-1-git-send-email-peter.ujfalusi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On Wed, Oct 31, 2012 at 03:54:37PM +0100, Peter Ujfalusi wrote:
> The correct chip id is 1 since the PWM module is on address 0x49. With the
> current TWL6030_MODULE_ID1 the kernel will crash early since:
> #define TWL6030_MODULE_ID1 0x0E
> and
> static struct twl_client twl_modules[4];
> 
> Down in the stack we try to get the module by:
> struct twl_client	*twl = &twl_modules[chip];
> 
> Which obviously going to do nasty things.
> 
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> ---
> Hi Samuel,
> 
> Can you push this patch to 3.7?
Applied to my for-linus branch. This should make it to 3.7.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
