Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab2IQXfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 19:35:43 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:13475 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757484Ab2IQXfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 19:35:42 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6838"; a="237836240"
Message-ID: <5057B3CD.1090805@codeaurora.org>
Date: Mon, 17 Sep 2012 16:35:41 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org
CC: linux-kernel@vger.kernel.org, Nicolas Pitre <nico@linaro.org>
Subject: Re: [PATCH] ARM: smp: Formalize an IPI for wakeup
References: <1347315869-28285-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1347315869-28285-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/12 15:24, Stephen Boyd wrote:
> Remove the offset from ipi_msg_type and assume that SGI0 is the
> wakeup interrupt now that all WFI hotplug users call
> gic_raise_softirq() with 0 instead of 1. This allows us to 
> track how many wakeup interrupts are sent and also removes the
> unknown IPI printk message for WFI hotplug based systems.
>
> Reviewed-by: Nicolas Pitre <nico@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---

I'm going to put this into the patch tracker in a few hours if there are
no further comments.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

