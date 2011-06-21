Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756294Ab1FUKIs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 06:08:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58680 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752752Ab1FUKIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 06:08:47 -0400
Date: Tue, 21 Jun 2011 11:08:40 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        patches@linaro.org, lrg@ti.com,
        MyungJoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH] regulator: MAX8997: Fix for divide by zero error
Message-ID: <20110621100839.GC22177@opensource.wolfsonmicro.com>
References: <1308627539-8980-1-git-send-email-tushar.behera@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308627539-8980-1-git-send-email-tushar.behera@linaro.org>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 09:08:59AM +0530, Tushar Behera wrote:
> Currently, ramp_delay variable is used uninitialzed in
> max8997_set_voltage_ldobuck which gets called through
> regulator_register calls.

> To fix the problem, in max8997_pmic_probe, ramp_delay initialization
> code is moved before calls to regulator_register.

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
