Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757373Ab1INSj7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 14:39:59 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:29037 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757299Ab1INSj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 14:39:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6469"; a="118630471"
Message-ID: <4E70F4F9.2000707@codeaurora.org>
Date: Wed, 14 Sep 2011 12:39:53 -0600
From: Kenneth Heitke <kheitke@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100722 Eudora/3.0.4
MIME-Version: 1.0
To: ben-linux@fluff.org
CC: Kenneth Heitke <kheitke@codeaurora.org>, khali@linux-fr.org,
        davidb@codeaurora.org, dwalker@fifo99.com, tsoni@codeaurora.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        linux-arm-msm@vger.kernel.org, seth.heasley@intel.com,
        arve@android.com, w.sang@pengutronix.de, tomoya-linux@dsn.okisemi.com,
        bryanh@codeaurora.org, linux-i2c@vger.kernel.org, swetland@google.com,
        sdharia@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        guenter.roeck@ericsson.com
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
>

Hi Ben,

Would it be possible to pull this driver into your tree?  If not, please 
let me know of any concerns that need to be addresses.

thanks,
Ken


-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
