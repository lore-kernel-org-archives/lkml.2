Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751768Ab1CIT3K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 14:29:10 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:40174 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1CIT3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 14:29:08 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6280"; a="78986748"
Message-ID: <4D77D502.1090606@codeaurora.org>
Date: Wed, 09 Mar 2011 11:29:06 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/4] SCM fixes and updates
References: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1298573085-23217-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/24/2011 10:44 AM, Stephen Boyd wrote:
> These are a few updates to SCM. The first two patches fix some
> bad code generation. The next patch saves a couple instructions
> on the slow path and the final patch determines the cacheline
> size dynamically instead of statically.
>
> Stephen Boyd (4):
>   msm: scm: Mark inline asm as volatile
>   msm: scm: Fix improper register assignment
>   msm: scm: Check for interruption immediately
>   msm: scm: Get cacheline size from CTR
>

Can we queue up patches 1 to 3 from this series for the next window? It
looks like everyone is ok with them. I'll respin the fourth patch once I
figure out where to go with it.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

