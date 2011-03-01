Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab1CAULr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:11:47 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55548 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab1CAULq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:11:46 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6271"; a="77193475"
From: David Brown <davidb@codeaurora.org>
To: Kenneth Heitke <kheitke@codeaurora.org>
Cc: bryanh@codeaurora.org, dwalker@fifo99.com, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.intradead.org, yanhe@codeaurora.org,
        palnatim@codeaurora.org, subhashj@codeaurora.org,
        Amir Samuelovi <amirs@codeaurora.org>,
        linux-arm-kernel@lists.infradead.org (open list:ARM PORT),
        linux-kernel@vger.kernel.org (open list)
Subject: Re: [RFC PATCH 5/5] RFC: msm: sps: Smart Peripheral System (SPS) driver.
References: <1298941892-25173-1-git-send-email-kheitke@codeaurora.org>
	<1298941892-25173-6-git-send-email-kheitke@codeaurora.org>
X-Hashcash: 1:20:110301:linux-arm-kernel@lists.infradead.org::OKYxN9JNZo70S1rk:00000000000000000000000000oFk
X-Hashcash: 1:20:110301:amirs@codeaurora.org::JHP1XSWB6Rsilro7:000000000000000000000000000000000000000001ZT5
X-Hashcash: 1:20:110301:subhashj@codeaurora.org::2AIzH4Hg1gptmqpT:000000000000000000000000000000000000000Yup
X-Hashcash: 1:20:110301:yanhe@codeaurora.org::boI0dqwsoVLbZFGO:000000000000000000000000000000000000000002Dzc
X-Hashcash: 1:20:110301:linux-arm-kernel@lists.intradead.org::yUF0EjebBT7F4OQ7:000000000000000000000000004lH
X-Hashcash: 1:20:110301:linux-arm-msm@vger.kernel.org::dIqgzcgPdTsOuR+u:000000000000000000000000000000004L8/
X-Hashcash: 1:20:110301:dwalker@fifo99.com::0kTnmt4Y8kTAt/OX:00000000000000000000000000000000000000000001GaP
X-Hashcash: 1:20:110301:bryanh@codeaurora.org::QEZf7CYXbN9QE/oZ:00000000000000000000000000000000000000001kcJ
X-Hashcash: 1:20:110301:palnatim@codeaurora.org::FbORTuwA4I+N7/xI:000000000000000000000000000000000000004RM/
X-Hashcash: 1:20:110301:kheitke@codeaurora.org::0CzxcCIvoGmnEzNt:000000000000000000000000000000000000000JpqJ
X-Hashcash: 1:20:110301:linux-kernel@vger.kernel.org::ML0iI5upL4T0y+LU:000000000000000000000000000000000Lh7N
Date: Tue, 01 Mar 2011 12:11:45 -0800
In-Reply-To: <1298941892-25173-6-git-send-email-kheitke@codeaurora.org>
	(Kenneth Heitke's message of "Mon, 28 Feb 2011 18:11:32 -0700")
Message-ID: <8yahbbmvbwe.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 28 2011, Kenneth Heitke wrote:

> diff --git a/arch/arm/mach-msm/include/mach/msm_sps.h b/arch/arm/mach-msm/include/mach/msm_sps.h
> +

> diff --git a/arch/arm/mach-msm/sps/Makefile b/arch/arm/mach-msm/sps/Makefile
> +

> diff --git a/arch/arm/mach-msm/sps/sps.c b/arch/arm/mach-msm/sps/sps.c
> +

> diff --git a/arch/arm/mach-msm/sps/sps_bam.c b/arch/arm/mach-msm/sps/sps_bam.c
> +

These four files add spurious blank lines to the end of their files.  If
there are no other changes to the patches, I can fix this up before
applying the patches.  Otherwise, please remove these before resending
the patches.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
