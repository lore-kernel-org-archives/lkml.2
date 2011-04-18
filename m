Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab1DRRoV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 13:44:21 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:47548 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756173Ab1DRRoO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 13:44:14 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6320"; a="86267497"
Message-ID: <4DAC786D.4020809@codeaurora.org>
Date: Mon, 18 Apr 2011 10:44:13 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Russell King <linux@arm.linux.org.uk>
CC: Jeff Ohlstein <johlstei@codeaurora.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: allow hotplug on msm
References: <1301078861-1991-1-git-send-email-johlstei@codeaurora.org>
In-Reply-To: <1301078861-1991-1-git-send-email-johlstei@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

On 3/25/2011 11:47 AM, Jeff Ohlstein wrote:
> Hotplug support was added in 9f1890a (msm: hotplug: support cpu hotplug
> on msm, 2010-12-02)
>
> Signed-off-by: Jeff Ohlstein <johlstei@codeaurora.org>

This fixes a Kconfig warning on MSM:

warning: (PM_SLEEP_SMP) selects HOTPLUG_CPU which has unmet direct
dependencies (SMP && HOTPLUG && EXPERIMENTAL && !ARCH_MSM)

Is there any way we can get this merged for .39 final? It's 6863/1 in
the patch tracker.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

