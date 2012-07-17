Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755634Ab2GQQee (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 12:34:34 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:37987 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab2GQQec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 12:34:32 -0400
Date: Tue, 17 Jul 2012 09:34:27 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: thomas.abraham@linaro.org, broonie@opensource.wolfsonmicro.com,
        grant.likely@secretlab.ca, sameo@linux.intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RESEND PATCH 1/2] mfd: add irq domain support for max8997
 interrupts
Message-ID: <20120717163427.GA3756@kroah.com>
References: <1341187375-16333-1-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341187375-16333-1-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 02, 2012 at 09:02:55AM +0900, Chanwoo Choi wrote:
> From: Thomas Abraham <thomas.abraham@linaro.org>
> 
> Add irq domain support for max8997 interrupts. The reverse mapping method
> used is linear mapping since the sub-drivers of max8997 such as regulator
> and charger drivers can use the max8997 irq_domain to get the linux irq
> number for max8997 interrupts. All uses of irq_base in platform data and
> max8997 driver private data are removed.
> 
> Signed-off-by: Thomas Abraham <thomas.abraham@linaro.org>
> Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Acked-by: Grant Likely <grant.likely@secretlab.ca>
> Acked-by: Samuel Ortiz <sameo@linux.intel.com>
> 	[Fix two bug which set max8997->irq_domain and correct wrong parameter]
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/mach-exynos/mach-nuri.c    |    4 --
>  arch/arm/mach-exynos/mach-origen.c  |    1 -
>  drivers/mfd/Kconfig                 |    1 +
>  drivers/mfd/max8997-irq.c           |   62 +++++++++++++++++++++--------------
>  drivers/mfd/max8997.c               |    1 -
>  include/linux/mfd/max8997-private.h |    4 ++-
>  include/linux/mfd/max8997.h         |    1 -
>  7 files changed, 41 insertions(+), 33 deletions(-)

Once again, this patch breaks the build.

Please be more careful with your patches, and TEST THEM BEFORE SENDING
THEM OUT.

ugh,

greg k-h
