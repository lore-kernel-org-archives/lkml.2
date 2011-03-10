Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129Ab1CJUhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 15:37:55 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6641 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007Ab1CJUhx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 15:37:53 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6281"; a="79242329"
From: David Brown <davidb@codeaurora.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: bryanh@codeaurora.org, linux@arm.linux.org.uk, dwalker@fifo99.com,
        dima@android.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] msm: gpio-v2: Add missing BIT field macros for interrupt control
In-Reply-To: <1299522832-31233-1-git-send-email-rvaswani@codeaurora.org>
	(Rohit Vaswani's message of "Mon, 7 Mar 2011 10:33:52 -0800")
References: <1299522832-31233-1-git-send-email-rvaswani@codeaurora.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
Date: Thu, 10 Mar 2011 12:37:59 -0800
Message-ID: <8yaoc5i90ew.fsf@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07 2011, Rohit Vaswani wrote:

> The gpio-v2 file was missing the BIT field macros causing incorrect
> values to be written at incorrect offsets within the TLMM block registers.
> These registers are used for masking/unmasking interrupts and configuring them
> This change fixes that problem.
>
> Change-Id: Ib538a2d09bca039b058627ddc309a7faaaf6bc8d
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>

Please remember to remove these Change-Id lines from patches before
sending them out.  I'll remove them from these patches, since there
don't seem to be any other comments.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
