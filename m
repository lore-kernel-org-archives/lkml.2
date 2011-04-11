Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753188Ab1DKRP0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 13:15:26 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2170 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab1DKRPZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 13:15:25 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6313"; a="85155484"
Message-ID: <4DA33720.5020206@codeaurora.org>
Date: Mon, 11 Apr 2011 10:15:12 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jesper Juhl <jj@chaosbits.net>
CC: Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] ARM: Kconfig.debug: Remove unused CONFIG_DEBUG_ERRORS
References: <1302300518-7523-1-git-send-email-sboyd@codeaurora.org> <alpine.LNX.2.00.1104101904000.17706@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1104101904000.17706@swampdragon.chaosbits.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But, I see a lot of *_defconfig files in my copy of the tree that 
> reference the option :
>
[snip]
> shouldn't those lines be removed as well?
>
> I can submit a patch, but I thought you'd rather do it yourself..
>

I was concerned that it would be more churn in the defconfigs. I can
make a patch for that too though. Or we could just wait for the
defconfigs to be regenerated and then the symbols would be dropped?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

