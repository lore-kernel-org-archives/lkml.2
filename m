Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756629Ab1BCRaZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:30:25 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59383 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756196Ab1BCRaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:30:24 -0500
MIME-Version: 1.0
In-Reply-To: <1296699283-6784-1-git-send-email-john.stultz@linaro.org>
References: <1296699283-6784-1-git-send-email-john.stultz@linaro.org>
From: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Date: Thu, 3 Feb 2011 15:30:02 -0200
Message-ID: <AANLkTimO5FXDoA_egZ=7oR5FTV-Fx5qpjfPRZ7eT1q50@mail.gmail.com>
Subject: Re: [PATCH 0/4] RTC regression fixups
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org, Alessandro Zummo <a.zummo@towertech.it>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,

On Thu, Feb 3, 2011 at 00:14, John Stultz <john.stultz@linaro.org> wrote:
> ...
> Marcelo: Mind giving this full patch set a go? It seems to resolve
> the issues in my testing with the rtc-test driver.

I have tested the full set in ARM sa1100. Both the sa1100 RTC driver
and the rtc-test driver are working fine.

The only difference in user space behaviour is, as I have mentioned on
a previous message, that the rtc-test driver receives PIE events no
matter what, while the previous behaviour was to receive them by
echoing through the sys interface. But we must think whether this is
something worth keeping or not.

You have actually saved me some work fixing the alarm/update broken
behaviour on sa1100. Thank you very much. Most of the code in this rtc
driver is going to /dev/null, I'll send a patch later.

Regards,
Marcelo.

Tested-by: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
