Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756159Ab1FCV1U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 17:27:20 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:26984 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751324Ab1FCV1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 17:27:19 -0400
Message-ID: <4DE951B0.4060802@tilera.com>
Date: Fri, 3 Jun 2011 17:27:12 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: <linux-kernel@vger.kernel.org>, John Stultz <johnstul@us.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 6/6] clocksource: tile: convert to use clocksource_register_hz
References: <1306913570-9445-1-git-send-email-john.stultz@linaro.org> <1306913570-9445-7-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1306913570-9445-7-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/1/2011 3:32 AM, John Stultz wrote:
> From: John Stultz <johnstul@us.ibm.com>
>
> Convert tile to use clocksource_register_hz.
>
> Untested. Help from maintainers would be appreciated.
>
> CC: Chris Metcalf <cmetcalf@tilera.com>
> CC: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: John Stultz <johnstul@us.ibm.com>
> ---
>  arch/tile/kernel/time.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)

Applied, thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


