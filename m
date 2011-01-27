Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137Ab1A0TpI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 14:45:08 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:26463 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648Ab1A0TpF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 14:45:05 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6239"; a="72232137"
Message-ID: <4D41CB40.20903@codeaurora.org>
Date: Thu, 27 Jan 2011 11:45:04 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        olof@lixom.net, konkers@android.com,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 15/28] ARM: tegra: irq: Add debugfs file to show wake
 irqs
References: <1295834493-5019-1-git-send-email-ccross@android.com> <1295834493-5019-16-git-send-email-ccross@android.com>
In-Reply-To: <1295834493-5019-16-git-send-email-ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2011 06:01 PM, Colin Cross wrote:
>
> +static int __init tegra_irq_debug_init(void)
> +{
> +	struct dentry *d;
> +
> +	d = debugfs_create_file("wake_irq", S_IRUGO, NULL, NULL,
> +		&tegra_wake_irq_debug_fops);
> +	if (!d) {
> +		pr_info("Failed to create suspend_mode debug file\n");

Does this want to be a pr_err()?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

