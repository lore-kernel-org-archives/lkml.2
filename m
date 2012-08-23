Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758273Ab2HWD5H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 23:57:07 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:47308 "EHLO
	relmlor1.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752508Ab2HWD5B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 23:57:01 -0400
X-IronPort-AV: E=Sophos;i="4.77,813,1336316400";   d="scan'208";a="94973752"
Message-id: <5035AA0B.7090003@renesas.com>
Date: Thu, 23 Aug 2012 12:56:59 +0900
From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713
 Thunderbird/14.0
MIME-version: 1.0
To: will.deacon@arm.com
Cc: sboyd@codeaurora.org, arnd@arndb.de, rmk+kernel@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] ARM: export read_current_timer
References: <1345645780-2749-1-git-send-email-arnd@arndb.de>
 <1345645780-2749-2-git-send-email-arnd@arndb.de>
 <503513A2.1030002@codeaurora.org>
 <20120822174945.GS9093@mudshark.cambridge.arm.com>
In-reply-to: <20120822174945.GS9093@mudshark.cambridge.arm.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/2012 2:49 AM, Will Deacon wrote:
> On Wed, Aug 22, 2012 at 06:15:14PM +0100, Stephen Boyd wrote:
>> On 08/22/12 07:29, Arnd Bergmann wrote:
>>> read_current_timer is used in the get_cycles() function when
>>> ARM_ARCH_TIMER is set, and that function can be inlined into
>>> driver modules, so we should export the function to avoid
>>> errors like
>>>
>>> ERROR: "read_current_timer" [drivers/video/udlfb.ko] undefined!
>>> ERROR: "read_current_timer" [crypto/tcrypt.ko] undefined!
>>>
>>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>>> Cc: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
>>
>> Acked-by: Stephen Boyd <sboyd@codeaurora.org>
>>
>> I ran into this last week but forgot to send the patch. Thanks.
> 
> Looks good to me, thanks Arnd:
> 
> Acked-by: Will Deacon <will.deacon@arm.com>

I haven't hit with this so far with our configs though, but why not?

Acked-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
