Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751957Ab1EUG3o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 02:29:44 -0400
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:50897 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751258Ab1EUG3i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 02:29:38 -0400
Message-ID: <4DD75BC9.8040004@ti.com>
Date: Sat, 21 May 2011 11:59:29 +0530
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.15) Gecko/20110303 Thunderbird/3.1.9
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
        Russell King <linux@arm.linux.org.uk>,
        Rob Herring <robherring2@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] ARM: smp_twd: Reconfigure clockevents after cpufreq
 change
References: <1305851091-10096-1-git-send-email-ccross@android.com>
In-Reply-To: <1305851091-10096-1-git-send-email-ccross@android.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/20/2011 5:54 AM, Colin Cross wrote:
> The localtimer's clock changes with the cpu clock.  After a
> cpufreq transition, update the clockevent's frequency and
> reprogram the next clock event.
>
> Adds a clock called "smp_twd" that is used to determine the
> twd frequency, which can also be used at init time to
> avoid calibrating the twd frequency.
>
> Clock changes are based on Rob Herring's work.
>
> Change-Id: I413b5cd07fb2b79bc9fad8b4bf257332d1da7bcd
> Signed-off-by: Colin Cross<ccross@android.com>
> Cc: Thomas Gleixner<tglx@linutronix.de>
> Cc: Russell King<linux@arm.linux.org.uk>
> Cc: Santosh Shilimkar<santosh.shilimkar@ti.com>
> Cc: Rob Herring<robherring2@gmail.com>
> Tested-by: Linus Walleij<linus.walleij@linaro.org>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@ti.com>

What about the clock-node patches?
Do you want those to get merged via sub-arch tree's once this
patch + Thomas's new API gets merged ?

Regards
Santosh
