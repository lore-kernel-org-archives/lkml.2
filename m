Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751343Ab1F3P4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 11:56:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58025 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750928Ab1F3P4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 11:56:38 -0400
Date: Thu, 30 Jun 2011 08:56:35 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: MyungJoo Ham <myungjoo.ham@gmail.com>
Cc: linux-kernel@vger.kernel.org, Samuel Ortiz <sameo@linux.intel.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>,
        Donggeun Kim <dg77.kim@samsung.com>
Subject: Re: [PATCH 3/3] MFD: MAX8997: IRQ definition moved to public header.
Message-ID: <20110630155634.GE3249@opensource.wolfsonmicro.com>
References: <1309397507-24959-1-git-send-email-myungjoo.ham@samsung.com>
 <1309397507-24959-3-git-send-email-myungjoo.ham@samsung.com>
 <20110630052808.GA796@opensource.wolfsonmicro.com>
 <BANLkTikGR-HdVZ-5h3kW64wiFduuuiU6Vw@mail.gmail.com>
 <20110630055719.GA930@opensource.wolfsonmicro.com>
 <BANLkTin4sCfX1Ahb_Td6VWH28s7SukYN-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTin4sCfX1Ahb_Td6VWH28s7SukYN-g@mail.gmail.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 05:00:13PM +0900, MyungJoo Ham wrote:

> In our code:
> http://git.infradead.org/users/kmpark/linux-2.6-samsung/blob/eba500212699c0ad8d6bde0dc01c3ec7101f8154:/arch/arm/mach-exynos4/setup-charger.c
> around line 85, it specifies which interrupt is going to be a
> wakeup-source ("true"), how the power-managing S/W should interpret
> them.

This looks like charger specific configuration which should be done by
the charger driver rather than by directly working with the IRQs?
