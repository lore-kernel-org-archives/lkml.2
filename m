Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758803Ab0IHNXv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 09:23:51 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27633 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab0IHNXs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 09:23:48 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6098"; a="53631372"
Message-ID: <4C878E60.3060000@codeaurora.org>
Date: Wed, 08 Sep 2010 18:53:44 +0530
From: Trilok Soni <tsoni@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Kenneth Heitke <kheitke@codeaurora.org>
CC: khali@linux-fr.org, ben-linux@fluff.org, srinidhi.kasagar@stericsson.com,
        linus.walleij@stericsson.com, linux-arm-msm@vger.kernel.org,
        arve@android.com, swetland@google.com, sdharia@codeaurora.com,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Crane Cai <crane.cai@amd.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org
Subject: Re: [PATCH v3] i2c: QUP based bus driver for Qualcomm MSM chipsets
References: <1283907557-1874-1-git-send-email-kheitke@codeaurora.org>
In-Reply-To: <1283907557-1874-1-git-send-email-kheitke@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/8/2010 6:29 AM, Kenneth Heitke wrote:
> This bus driver supports the QUP i2c hardware controller in the Qualcomm
> MSM SOCs.  The Qualcomm Universal Peripheral Engine (QUP) is a general
> purpose data path engine with input/output FIFOs and an embedded i2c
> mini-core. The driver supports FIFO mode (for low bandwidth applications)
> and block mode (interrupt generated for each block-size data transfer).
> The driver currently does not support DMA transfers.
> 
> Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
> ---
> v3: uses DIV_ROUND_UP() as recommended by linus.walleij@stericsson.com
> v2: incorporated feedback from the following people:
> 	ben-linux@fluff.org
> 	srinidhi.kasagar@stericsson.com
> 	tsoni@codeaurora.org

Looks good to me.

Acked-by: Trilok Soni <tsoni@codeaurora.org>

---Trilok Soni

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
