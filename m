Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877Ab1GDOJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 10:09:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:49926 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752046Ab1GDOJN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 10:09:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,472,1304319600"; 
   d="scan'208";a="23238597"
Date: Mon, 4 Jul 2011 16:09:37 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Donggeun Kim <dg77.kim@samsung.com>
Cc: cbouatmailru@gmail.com, broonie@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com,
        kyungmin.park@samsung.com
Subject: Re: [PATCH] power_supply: Add charger driver for MAX8997/8966
Message-ID: <20110704140937.GD3021@sortiz-mobl>
References: <1308739206-7802-1-git-send-email-dg77.kim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308739206-7802-1-git-send-email-dg77.kim@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 07:40:06PM +0900, Donggeun Kim wrote:
> MAX8997/8966 chip is a multi-function device which includes
> PMIC, RTC, Fuel Gauge, MUIC, Haptic, Flash control, and
> Battery charging control.
> The driver for it is located at drivers/mfd.
> 
> This patch supports battery charging control of MAX8997/8966 chip and
> provides power supply class information to userspace.
> 
> Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: KyungMin Park <kyungmin.park@samsung.com>
In case Anton needs it, for the MFD part:

Acked-by: Samuel Ortiz <sameo@linux.intel.com>

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
