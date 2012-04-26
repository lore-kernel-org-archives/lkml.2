Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756505Ab2DZRvw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 13:51:52 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:50537 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716Ab2DZRvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 13:51:50 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6693"; a="185226554"
Message-ID: <4F998B34.4090403@codeaurora.org>
Date: Thu, 26 Apr 2012 10:51:48 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org
Subject: Re: [PATCH] Move most arches to asm-generic/current.h
References: <1335237509-17113-1-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1335237509-17113-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/12 20:18, Stephen Boyd wrote:
> Make get_current() into a static inline function in the
> generic version of current.h so we match what almost every
> architecture is doing. This allows us to move most of the arches
> over to this generic header instead of redefining the same thing
> over and over in each asm directory.
>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> Cc: linux-arch@vger.kernel.org
> ---
> diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
> index e423def..8b8f979 100644
> --- a/arch/alpha/include/asm/Kbuild
> +++ b/arch/alpha/include/asm/Kbuild
> @@ -2,6 +2,7 @@ include include/asm-generic/Kbuild.asm
>  
>  header-y += compiler.h
>  header-y += console.h
> +header-y += current.h

Oops. This should be generic-y not header-y.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

