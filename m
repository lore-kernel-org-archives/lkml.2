Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754946Ab1HDRZB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 13:25:01 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:9275 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab1HDRY4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 13:24:56 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6428"; a="108150199"
Message-ID: <4E3AD5E7.6040105@codeaurora.org>
Date: Thu, 04 Aug 2011 10:24:55 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-sh@vger.kernel.org, Kevin Hilman <khilman@deeprootsystems.com>,
        Paul Mundt <lethal@linux-sh.org>, x86@kernel.org,
        Len Brown <len.brown@intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] cpuidle: Consistent spelling of cpuidle_idle_call()
References: <1312475071-22973-1-git-send-email-davidb@codeaurora.org>
In-Reply-To: <1312475071-22973-1-git-send-email-davidb@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2011 09:24 AM, David Brown wrote:
> Commit a0bfa1373859e9d11dc92561a8667588803e42d8 mispells
> cpuidle_idle_call() on ARM and SH code.  Fix this to be consistent.
>
> Cc: Kevin Hilman <khilman@deeprootsystems.com>
> Cc: Paul Mundt <lethal@linux-sh.org>
> Cc: x86@kernel.org
> Cc: Len Brown <len.brown@intel.com>
> Signed-off-by: David Brown <davidb@codeaurora.org>
> ---
> The referenced commit breaks compilation on ARM, and appears it would
> do so on SH as well.

Mark Brown sent this patch[1] months ago when this build breakage was
noticed in linux-next. What happened to that patch? It looks like the
patch that introduced the breakage was pulled from linux-next shortly
after and then reintroduced today.

[1]https://lkml.org/lkml/2011/4/4/109

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

