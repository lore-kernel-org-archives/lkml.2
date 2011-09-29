Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab1I2CFT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 22:05:19 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:57140 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724Ab1I2CFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 22:05:17 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6483"; a="123313567"
Message-ID: <4E83D25C.6020306@codeaurora.org>
Date: Wed, 28 Sep 2011 19:05:16 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:6.0.2) Gecko/20110902 Thunderbird/6.0.2
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: linux-arm-kernel@lists.infradead.org, Will Deacon <will.deacon@arm.com>,
        linux-kernel@vger.kernel.org, David Brown <davidb@codeaurora.org>
Subject: Re: [PATCHv2 2/2] ARM: debug: Move DEBUG_ICEDCC into the DEBUG_LL
 choice
References: <1316568208-4518-1-git-send-email-sboyd@codeaurora.org> <1316568208-4518-2-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1316568208-4518-2-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/11 18:23, Stephen Boyd wrote:
> DEBUG_ICEDCC support is just another DEBUG_LL choice and
> selecting it along with other DEBUG_LL options doesn't make
> much sense. Put it into the DEBUG_LL choice to avoid confusion.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Acked-by: Will Deacon <will.deacon@arm.com>
> ---
>

Chatting with David Brown made me realize that this patch now forces
ICEDCC for anybody who selects DEBUG_LL and hasn't moved to adding a
Kconfig in the choice menu. I'm not sure if that actually matters since
it may be incentive to put your machine of choice into this menu.

Otherwise, we may want to drop this until a later point, or just leave
it out of the choice menu altogether.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

