Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933037Ab0LTSjo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 13:39:44 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:46861 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932563Ab0LTSjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 13:39:43 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6203"; a="67586317"
Message-ID: <4D0FA2EE.90703@codeaurora.org>
Date: Mon, 20 Dec 2010 10:39:42 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Daniel Walker <dwalker@codeaurora.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tony Lindgren <tony@atomide.com>, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>
Subject: Re: [PATCH] hvc_dcc: Simplify assembly for v6 and v7 ARM
References: <20101201192856.GA731@suse.de>	 <1292649385-28771-1-git-send-email-sboyd@codeaurora.org> <1292867461.27552.15.camel@m0nster>
In-Reply-To: <1292867461.27552.15.camel@m0nster>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2010 09:51 AM, Daniel Walker wrote:
>
> I would expect to see three patches. One that adds volatile, which
> appears to be a good fix. Another patch that changes the assembly lines,
> and another that does the clean up. The last two are more controversial
> ones

Ok. I'll send a series later today to give some more time for feedback.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

