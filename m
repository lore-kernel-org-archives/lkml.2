Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755165Ab1BGWJr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 17:09:47 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55692 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755131Ab1BGWJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 17:09:46 -0500
Date: Mon, 7 Feb 2011 22:09:34 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Marcelo Roberto Jimenez <mroberto@cpti.cetuc.puc-rio.br>
Cc: linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com,
        john.stultz@linaro.org, tglx@linutronix.de, a.zummo@towertech.it
Subject: Re: [PATCH 0/4] RTC: Updates for RTC.
Message-ID: <20110207220934.GF5853@n2100.arm.linux.org.uk>
References: <1297113368-27174-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297113368-27174-1-git-send-email-mroberto@cpti.cetuc.puc-rio.br>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think it would be more relevant for you to send your patches _to_
Alessandro Zummo rather than to me, as I have much interest in this,
and it's Alessandro who you want to merge it.  Alessandro is the RTC
maintainer.

On Mon, Feb 07, 2011 at 07:16:04PM -0200, Marcelo Roberto Jimenez wrote:
> The following set of patches are updates to the RTC code to take into account
> the new emulated periodic interrupts using hrtimers.
> 
> [PATCH 1/4] RTC: Include information about UIE and PIE in RTC driver proc.
> [PATCH 2/4] RTC: Remove UIE and PIE information from the sa1100 driver proc.
> [PATCH 3/4] RTC: Fix the cross interrupt issue on rtc-test.
> [PATCH 4/4] RTC: sa1100: Update the sa1100 RTC driver.
> 
>  drivers/rtc/rtc-proc.c   |   22 ++++++---
>  drivers/rtc/rtc-sa1100.c |  122 ++--------------------------------------------
>  drivers/rtc/rtc-test.c   |   13 +++--
>  3 files changed, 29 insertions(+), 128 deletions(-)
> 
