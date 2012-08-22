Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964909Ab2HVRPT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 13:15:19 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:34779 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964824Ab2HVRPQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 13:15:16 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6811"; a="228238780"
Message-ID: <503513A2.1030002@codeaurora.org>
Date: Wed, 22 Aug 2012 10:15:14 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/4] ARM: export read_current_timer
References: <1345645780-2749-1-git-send-email-arnd@arndb.de> <1345645780-2749-2-git-send-email-arnd@arndb.de>
In-Reply-To: <1345645780-2749-2-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/12 07:29, Arnd Bergmann wrote:
> read_current_timer is used in the get_cycles() function when
> ARM_ARCH_TIMER is set, and that function can be inlined into
> driver modules, so we should export the function to avoid
> errors like
>
> ERROR: "read_current_timer" [drivers/video/udlfb.ko] undefined!
> ERROR: "read_current_timer" [crypto/tcrypt.ko] undefined!
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>

Acked-by: Stephen Boyd <sboyd@codeaurora.org>

I ran into this last week but forgot to send the patch. Thanks.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

