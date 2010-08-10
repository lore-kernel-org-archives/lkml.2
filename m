Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067Ab0HJWrB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 18:47:01 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64752 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754750Ab0HJWq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 18:46:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6070"; a="50567361"
Message-ID: <4C61D6E3.1030603@codeaurora.org>
Date: Tue, 10 Aug 2010 15:46:59 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.4) Gecko/20100608 Thunderbird/3.1
MIME-Version: 1.0
To: linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: uaccess: Implement strict user copy checks
References: <1280890950-19174-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1280890950-19174-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2010 08:02 PM, Stephen Boyd wrote:
> This is mostly a copy from the s390 implementation (which copied
> from x86 and sparc), except we print a warning if the Kconfig
> option is disabled.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
>

Ping?

Should I submit this to the patch system?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
