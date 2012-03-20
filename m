Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758957Ab2CTA36 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 20:29:58 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:25977 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134Ab2CTA35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 20:29:57 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6654"; a="173890283"
Date: Mon, 19 Mar 2012 17:29:55 -0700
From: David Brown <davidb@codeaurora.org>
To: "peter.meng" <mengsanshui@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: How about the MMC/SDIO host controller standard under Linux ?
Message-ID: <20120320002955.GA26604@codeaurora.org>
References: <CADvmyBeNXHgknSUJazJY5EVueZHMcqJ7FpVEZT8kkv-bzb+F0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADvmyBeNXHgknSUJazJY5EVueZHMcqJ7FpVEZT8kkv-bzb+F0w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 19, 2012 at 10:39:29AM +0800, peter.meng wrote:

> I see the drivers/mmc/host/sdhci.h define the common register as
> describe within
> Part_A2_SD_Host_Controller_Simplified_Specification_Ver3.00_Final_110225.pdf
> In this case all command related access register is common .(sdhci-xxx.c)
> Does this mean all sdhci-xxx.c that will support SD host controller  standard ?

> I see most code  such as s3cmci.c ,msm_sdcc.c that has their only
> private register that access by such as mmc_host_ops->request function
> .
> I want to know whether this mean these host controller doesn't support
>  SD host controller standard ?

There are numerous SD host controllers that aren't SDHCI.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
