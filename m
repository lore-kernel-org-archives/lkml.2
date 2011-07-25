Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752275Ab1GYRke (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 13:40:34 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52199 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646Ab1GYRkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 13:40:32 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6418"; a="105555790"
Date: Mon, 25 Jul 2011 10:40:31 -0700
From: David Brown <davidb@codeaurora.org>
To: ben-linux@fluff.org
Cc: Kenneth Heitke <kheitke@codeaurora.org>, khali@linux-fr.org,
        davidb@codeaurora.org, dwalker@fifo99.com,
        linux-arm-msm@vger.kernel.org, bryanh@codeaurora.org,
        tsoni@codeaurora.org, arve@android.com, swetland@google.com,
        sdharia@codeaurora.org, linux-arm-kernel@lists.infradead.org,
        seth.heasley@intel.com, tomoya-linux@dsn.okisemi.com,
        guenter.roeck@ericsson.com, linus.walleij@stericsson.com,
        w.sang@pengutronix.de, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] i2c: QUP based bus driver for Qualcomm MSM chipsets
Message-ID: <20110725174030.GA20835@huya.qualcomm.com>
References: <1308018114-19709-1-git-send-email-kheitke@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308018114-19709-1-git-send-email-kheitke@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 13, 2011 at 08:21:53PM -0600, Kenneth Heitke wrote:
> This bus driver supports the QUP i2c hardware controller in the Qualcomm
> MSM SOCs.  The Qualcomm Universal Peripheral Engine (QUP) is a general
> purpose data path engine with input/output FIFOs and an embedded i2c
> mini-core. The driver supports FIFO mode (for low bandwidth applications)
> and block mode (interrupt generated for each block-size data transfer).
> The driver currently does not support DMA transfers.
> 
> Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>

Ben, I was wondering if there were any outstanding issues with this
driver that Ken needs to address, or if it just got overlooked.

FWIW:
  Acked-By: David Brown <davidb@codeaurora.org>

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
