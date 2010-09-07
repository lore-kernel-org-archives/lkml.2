Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758245Ab0IGXbZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 19:31:25 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:17661 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755505Ab0IGXbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 19:31:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6098"; a="53560520"
Date: Tue, 7 Sep 2010 16:31:19 -0700
From: David Brown <davidb@codeaurora.org>
To: Kenneth Heitke <kheitke@codeaurora.org>
Cc: khali@linux-fr.org, ben-linux@fluff.org, srinidhi.kasagar@stericsson.com,
        tsoni@codeaurora.org, linux-arm-msm@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/2] msm: i2c: Add msm_qup_i2c.h
Message-ID: <20100907233119.GA2707@huya.qualcomm.com>
References: <1283471059-22262-1-git-send-email-kheitke@codeaurora.org>
 <1283471059-22262-2-git-send-email-kheitke@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1283471059-22262-2-git-send-email-kheitke@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 02, 2010 at 05:44:19PM -0600, Kenneth Heitke wrote:
> Defines the platform data used by the MSM QUP I2C driver.
> 
> Signed-off-by: Kenneth Heitke <kheitke@codeaurora.org>
> ---
>  arch/arm/mach-msm/include/mach/msm_qup_i2c.h |   28 ++++++++++++++++++++++++++
>  1 files changed, 28 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/mach-msm/include/mach/msm_qup_i2c.h

Acked-by: David Brown <davidb@codeaurora.org>

It's probably easiest to just keep this patch together with the other
one, and bring them both into the I2C code together.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
