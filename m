Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753359Ab1A0Ui3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 15:38:29 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15036 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab1A0Ui1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 15:38:27 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6239"; a="72238307"
Message-ID: <4D41D7C2.3080608@codeaurora.org>
Date: Thu, 27 Jan 2011 12:38:26 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-tegra@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        konkers@android.com, Gary King <gking@nvidia.com>,
        linux-kernel@vger.kernel.org, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 18/28] ARM: tegra: add CPU_IDLE driver
References: <1295834493-5019-1-git-send-email-ccross@android.com> <1295834493-5019-19-git-send-email-ccross@android.com>
In-Reply-To: <1295834493-5019-19-git-send-email-ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2011 06:01 PM, Colin Cross wrote:
>
> +static int __init tegra_cpuidle_debug_init(void)
> +{
> +	struct dentry *dir;
> +	struct dentry *d;
> +
> +	dir = debugfs_create_dir("cpuidle", NULL);
> +	if (!dir)
> +		return -ENOMEM;
> +
> +	d = debugfs_create_file("lp2", S_IRUGO, dir, NULL,
> +		&tegra_lp2_debug_ops);
> +	if (!d)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +#endif
> +
> +late_initcall(tegra_cpuidle_debug_init);

Will this compile with CONFIG_DEBUG_FS=n?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

