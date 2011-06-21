Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab1FUDu4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 23:50:56 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:63080 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752840Ab1FUDuy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 23:50:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6383"; a="98796660"
Message-ID: <4E00151B.90308@codeaurora.org>
Date: Mon, 20 Jun 2011 21:50:51 -0600
From: Kenneth Heitke <kheitke@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100722 Eudora/3.0.4
MIME-Version: 1.0
To: ben-linux@fluff.org
CC: Kenneth Heitke <kheitke@codeaurora.org>, khali@linux-fr.org,
        davidb@codeaurora.org, dwalker@fifo99.com,
        linux-arm-msm@vger.kernel.org, bryanh@codeaurora.org,
        tsoni@codeaurora.org, arve@android.com, swetland@google.com,
        sdharia@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        seth.heasley@intel.com, tomoya-linux@dsn.okisemi.com,
        guenter.roeck@ericsson.com, linus.walleij@stericsson.com,
        w.sang@pengutronix.de, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: QUP based bus driver for Qualcomm MSM chipsets
References: <1308018114-19709-1-git-send-email-kheitke@codeaurora.org>
In-Reply-To: <1308018114-19709-1-git-send-email-kheitke@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/13/2011 08:21 PM, Kenneth Heitke wrote:
> This bus driver supports the QUP i2c hardware controller in the Qualcomm
> MSM SOCs.  The Qualcomm Universal Peripheral Engine (QUP) is a general
> purpose data path engine with input/output FIFOs and an embedded i2c
> mini-core. The driver supports FIFO mode (for low bandwidth applications)
> and block mode (interrupt generated for each block-size data transfer).
> The driver currently does not support DMA transfers.
>
> Signed-off-by: Kenneth Heitke<kheitke@codeaurora.org>
> ---
> v2: updates to runtime PM calls (addresses comments from Mark Brown).
>      Disable interrupts before setting completion object to NULL (bug fix).
> ---
>   drivers/i2c/busses/Kconfig                |   11 +
>   drivers/i2c/busses/Makefile               |    1 +
>   drivers/i2c/busses/i2c-qup.c              | 1175 +++++++++++++++++++++++++++++
>   include/linux/platform_data/msm_qup_i2c.h |   24 +
>   4 files changed, 1211 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/i2c/busses/i2c-qup.c
>   create mode 100644 include/linux/platform_data/msm_qup_i2c.h

Hi Ben,

If there are no objections to this i2c driver, can it be pulled into 
your -next tree?

thank you,
Ken

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
