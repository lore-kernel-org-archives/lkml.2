Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753544Ab0LFVHh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 16:07:37 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:53468 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181Ab0LFVHg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 16:07:36 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6189"; a="65701234"
Message-ID: <4CFD5092.50809@codeaurora.org>
Date: Mon, 06 Dec 2010 13:07:30 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-tegra@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        Erik Gilling <konkers@android.com>, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 14/21] ARM: tegra: irq: Add debugfs file to show wake
 irqs
References: <1291590548-7341-1-git-send-email-ccross@android.com> <1291590548-7341-15-git-send-email-ccross@android.com>
In-Reply-To: <1291590548-7341-15-git-send-email-ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2010 03:09 PM, Colin Cross wrote:
> +static int __init tegra_irq_debug_init(void)
> +{
> +	struct dentry *d;
> +
> +	d = debugfs_create_file("wake_irq", 0755, NULL, NULL,
> +		&tegra_wake_irq_debug_fops);

Why not use S_IRUGO? And why is this file executable?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

