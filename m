Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932996Ab1EXV3X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 17:29:23 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:45678 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757614Ab1EXV3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 17:29:20 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6356"; a="93391523"
Message-ID: <4DDC232F.7080005@codeaurora.org>
Date: Tue, 24 May 2011 14:29:19 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Intel Linux Wireless <ilw@linux.intel.com>,
        linux-scsi@vger.kernel.org, x86@kernel.org,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 0/9] strict user copy checks on x86_64
References: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

(I don't know who to pick on sorry)

On 05/12/2011 04:50 PM, Stephen Boyd wrote:
> It turns out that strict user copy checks (also known as
> CONFIG_DEBUG_STRICT_USER_COPY_CHECKS) isn't actually implemented
> on x86_64 and thus we aren't catching potential security holes
> at compile time.
>
> This series adds support for strict user copy checks on x86_64
> and silences all the benign warnings in the x86_64 allyesconfig.
>
> The final patch consolidates the config option as its duplicated
> across mutliple arches. I don't know what tree this series should
> go through so I tried to send the individual driver patches to the
> respective maintainers.
>
> Stephen Boyd (9):
>   iwlegacy: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
>   iwlwifi: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
>   [SCSI] lpfc: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
>   debugfs: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
>   kprobes: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
>   Bluetooth: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
>   ASoC: Silence DEBUG_STRICT_USER_COPY_CHECKS=y warning
>   x86: Implement strict user copy checks for x86_64
>   Consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS

It looks like 1, 2, 4, 6, and 7 got picked up. Should I resend the left
over patches with appropriate acked-bys and tags? Would it be
appropriate to push this through your tree?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

