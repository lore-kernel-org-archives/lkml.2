Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755824Ab2LSR5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 12:57:16 -0500
Received: from mail-ie0-f181.google.com ([209.85.223.181]:56478 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab2LSR5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 12:57:06 -0500
Message-ID: <50D1FFEC.10906@linaro.org>
Date: Wed, 19 Dec 2012 09:57:00 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Magnus Damm <magnus.damm@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org, horms@verge.net.au,
        shinya.kuribayashi.px@renesas.com, tglx@linutronix.de
Subject: Re: [PATCH 00/08] clocksource: sh_cmt: CMT driver update
References: <20121214055323.10081.12056.sendpatchset@w520>
In-Reply-To: <20121214055323.10081.12056.sendpatchset@w520>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2012 09:53 PM, Magnus Damm wrote:
> clocksource: sh_cmt: CMT driver update
>
> [PATCH 01/08] clocksource: sh_cmt: Take care of clk_put() when setup_irq() fails
> [PATCH 02/08] clocksource: sh_cmt: Initialize 'max_match_value' and 'lock' in sh_cmt_setup()
> [PATCH 03/08] clocksource: sh_cmt: Consolidate platform_set_drvdata() call
> [PATCH 04/08] clocksource: sh_cmt: Introduce per-register functions
> [PATCH 05/08] clocksource: sh_cmt: CMSTR and CMCSR register access update
> [PATCH 06/08] clocksource: sh_cmt: CMCNT and CMCOR register access update
> [PATCH 07/08] clocksource: sh_cmt: Add control register callbacks
> [PATCH 08/08] clocksource: sh_cmt: Add CMT register layout comment
>
> This patch series contains a couple of driver updates from Kuribayashi-san
> together with some register access changes from me. The register access
> changes work towards adding support for 32-bit only CMT hardware, but
> the final bits are not yet included in this series due to lack of hardware.
>
> Patches 1-3:
> Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> Signed-off-by: Magnus Damm <damm@opensource.se>
>
> Patches 4-8:
> Signed-off-by: Magnus Damm <damm@opensource.se>
Due to unfamiliarity with the hardware, I can't really review these 
changes, so I'd prefer they be merged through the arch tree, where it 
can get proper review/testing.

Acked-by: John Stultz <john.stultz@linaro.org>

thanks
-john

