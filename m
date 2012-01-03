Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab2ACX06 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 18:26:58 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49724 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752312Ab2ACX04 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 18:26:56 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6578"; a="151960048"
Message-ID: <4F038EBF.5030408@codeaurora.org>
Date: Tue, 03 Jan 2012 15:26:55 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Simon Glass <sjg@chromium.org>
CC: linux-arm-kernel@lists.infradead.org, Ben Hutchings <ben@decadent.org.uk>,
        Olof Johansson <olofj@chromium.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Martin <dave.martin@linaro.org>
Subject: Re: [PATCH] ARM: Remove BUILD_BUG_ON from asm/bug.h
References: <1325616276-10304-1-git-send-email-sjg@chromium.org>	<4F03821D.9080503@codeaurora.org> <CAPnjgZ1P6bdAGRa-9ZyuNMT7jRAfrH3abWJPkxVeeM7BDKsXTg@mail.gmail.com>
In-Reply-To: <CAPnjgZ1P6bdAGRa-9ZyuNMT7jRAfrH3abWJPkxVeeM7BDKsXTg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/03/12 14:40, Simon Glass wrote:
> Yes that is the reason, but ARM is not unique in this matter, and
> other archs do not have this check. I did suggest a solution in this
> thread involving putting the check in a C file instead of header. But
> it needs an arch-specific #define to specify the size expected by the
> assembler, and has the disadvantage of moving the check away from the
> assembler code.
>
> It's not that we don't want this check, more that it is not essential
> (since there is currently no mismatch), it is causing problems and it
> is risky to try to solve this problem some other way at this late
> stage in 3.2. So the easiest thing is to remove it, to match other
> archs.

Fair enough. I now see the other thread where this has all been
discussed. Sorry for the noise.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

