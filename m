Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166Ab1AXTTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:19:54 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11889 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab1AXTTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:19:53 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6236"; a="71787612"
Message-ID: <4D3DD0D8.10905@codeaurora.org>
Date: Mon, 24 Jan 2011 11:19:52 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6
MIME-Version: 1.0
To: Catalin Marinas <catalin.marinas@arm.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v4 01/19] ARM: Make the argument to virt_to_phys() "const
 volatile"
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <1295891761-18366-2-git-send-email-catalin.marinas@arm.com>
In-Reply-To: <1295891761-18366-2-git-send-email-catalin.marinas@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/24/2011 09:55 AM, Catalin Marinas wrote:
> Changing the virt_to_phys() argument to "const volatile void *" avoids
> compiler warnings in some situations where this function is used.
>
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> Cc: Arnd Bergmann <arnd@arndb.de>
> ---

Acked-by: Stephen Boyd <sboyd@codeaurora.org>

Any chance we can get this one patch into 2.6.38? It fixes a warning for
MSM.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

