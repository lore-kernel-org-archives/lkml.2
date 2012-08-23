Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab2HWEX7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 00:23:59 -0400
Received: from relmlor1.renesas.com ([210.160.252.171]:50319 "EHLO
	relmlor1.renesas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750820Ab2HWEXz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 00:23:55 -0400
X-IronPort-AV: E=Sophos;i="4.77,813,1336316400";   d="scan'208";a="94979182"
Message-id: <5035B05C.4020104@renesas.com>
Date: Thu, 23 Aug 2012 13:23:56 +0900
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
 <50351D80.6010600@codeaurora.org>
 <20120822175810.GT9093@mudshark.cambridge.arm.com>
In-reply-to: <20120822175810.GT9093@mudshark.cambridge.arm.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/23/2012 2:58 AM, Will Deacon wrote:
> On Wed, Aug 22, 2012 at 06:57:20PM +0100, Stephen Boyd wrote:
>> On 08/22/12 10:49, Will Deacon wrote:
>>> On the topic of the timer stuff: Shinya/Stephen, did you have a chance to
>>> look at the registration stuff that was proposed? I'm happy to push it if
>>> people will actually use it.
>>
>> Yes I have tested it on our internal trees and it looks good. I plan to
>> send a patch to move MSM's timers over to it later this week so that we
>> have at least two users upstream.

And I think other A9 MPcore platforms, namely OMAP and EXYNOS, would
also be candidates, who tried to skip calibrate_delay() in the past
(OMAP) or currently provide non-smp_twd timers as localtimers (EXYNOS).
I may miss the latest status of those BSPs, but believe that we would
have more users (>2) in the future.

> Awesome, I'll dust that series off at -rc3 then.

It works for me for weeks without troubles, looking forward to it.
--
Shinya Kuribayashi
Renesas Electronics
