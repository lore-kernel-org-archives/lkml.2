Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932579Ab2GEOJ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:09:26 -0400
Received: from mga02.intel.com ([134.134.136.20]:59184 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753447Ab2GEOJZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:09:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="161707177"
Date: Thu, 5 Jul 2012 16:20:46 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: gregkh@linuxfoundation.org, thomas.abraham@linaro.org,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 0/2] mfd: MAX8997: Support irq domain for Maxim
 MAX8997
Message-ID: <20120705142046.GC18200@sortiz-mobl>
References: <1341187362-16298-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341187362-16298-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chanwoo,

On Mon, Jul 02, 2012 at 09:02:42AM +0900, Chanwoo Choi wrote:
> This patchset add support irq domain for Maxim MAX8997 interrupts.
> 
> I have discussed about this patchset with Greg KH and received below reply.
> So, I resend this patchset.
> - https://lkml.org/lkml/2012/5/20/142
> 
> This first patch is based on patch written by Thomas Abraham
> (https://lkml.org/lkml/2012/4/18/145) but this patch had occurred
> build break, it was reported by Stephen Rothwell and this patch was
> reverted by Mark Brown. You can check reverted patch on below patch.
> - http://git.kernel.org/?p=linux/kernel/git/broonie/regulator.git;a=commit;h=82b719b11fd750188c125078ad6a6c0d23219dfb
> So I fix two bug which set max88997->irq_domain instead
> of NULL pointer and correct wrong parameter.
> 
> The second patch use irq domain for muic interrupt of extcon-max8997
> instead of irq_base in platform data of MAX8997 driver.
> 
> Chanwoo Choi (1):
>   Extcon: MAX8997: Add support irq domain for MAX8997 muic
> 
> Thomas Abraham (1):
>   mfd: add irq domain support for max8997 interrupts
Both patches applied to my for-next branch, thanks.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
