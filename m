Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125Ab1C1TNl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 15:13:41 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:21137 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755383Ab1C1TNk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 15:13:40 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6299"; a="82538423"
From: David Brown <davidb@codeaurora.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
Cc: bryanh@codeaurora.org, linux@arm.linux.org.uk, dwalker@fifo99.com,
        dima@android.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCHv2 1/3] msm: Remove arch-specific gpiomux tables
References: <1299522922-31294-1-git-send-email-rvaswani@codeaurora.org>
Date: Mon, 28 Mar 2011 12:14:31 -0700
In-Reply-To: <1299522922-31294-1-git-send-email-rvaswani@codeaurora.org>
	(Rohit Vaswani's message of "Mon, 7 Mar 2011 10:35:22 -0800")
Message-ID: <8yatyenukfc.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 07 2011, Rohit Vaswani wrote:

> Remove arch-specific gpiomux files and include the gpiomux configs
> as a part of the board file.
>
> Change-Id: I83de33c6d5f9e8e91832d8173d31a96cf11ce592
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
> v2: Re-send
>
>  arch/arm/mach-msm/Makefile        |    4 +-
>  arch/arm/mach-msm/board-msm8x60.c |    3 ++
>  arch/arm/mach-msm/board-qsd8x50.c |   12 ++++++++
>  arch/arm/mach-msm/gpiomux-8x50.c  |   51 -------------------------------------
>  arch/arm/mach-msm/gpiomux-8x60.c  |   19 -------------
>  5 files changed, 17 insertions(+), 72 deletions(-)
>  delete mode 100644 arch/arm/mach-msm/gpiomux-8x50.c
>  delete mode 100644 arch/arm/mach-msm/gpiomux-8x60.c

Rohit, this change seems to have broken MMC/SD on the 8x50 target.  I'm
going to need to pull these out of my 'for-40' branch.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
