Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab2FGRXs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:23:48 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2147 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759840Ab2FGRXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:23:47 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6735"; a="198781115"
Message-ID: <4FD0E3A2.5050303@codeaurora.org>
Date: Thu, 07 Jun 2012 10:23:46 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] memblock: Document memblock_is_region_{memory,reserved}()
References: <1337845521-32755-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1337845521-32755-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/12 00:45, Stephen Boyd wrote:
> At first glance one would think that memblock_is_region_memory()
> and memblock_is_region_reserved() would be implemented in the
> same way. Unfortunately they aren't and the former returns
> whether the region specified is a subset of a memory bank while
> the latter returns whether the region specified intersects with
> reserved memory.
>
> Document the two functions so that users aren't tempted to
> make the implementation the same between them and to clarify the
> purpose of the functions.
>
> Cc: Tejun Heo <tj@kernel.org>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---

Hi Ingo, can you pick up or review this patch (I realize it was sent
during the merge window)?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

