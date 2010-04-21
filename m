Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab0DUVf3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 17:35:29 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:46446 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755329Ab0DUVf0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 17:35:26 -0400
Subject: Re: [PATCH 1/2] arch/avr32: Fix build failure caused by typo
From: john stultz <johnstul@us.ibm.com>
To: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: Haavard Skinnemoen <hskinnemoen@atmel.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
In-Reply-To: <201004212318.23909.PeterHuewe@gmx.de>
References: <201004212318.23909.PeterHuewe@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Apr 2010 14:35:21 -0700
Message-ID: <1271885721.3231.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-04-21 at 23:18 +0200, Peter Hüwe wrote:
> From: Peter Huewe <peterhuewe@gmx.de>
> 
> This little patch fixes a build failure[1] caused by a typo.
> 
> Patch against linux-next20100421
> 
> References:
> [1]http://kisskb.ellerman.id.au/kisskb/buildresult/2448162/
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>

Ah! Sorry about that. Thanks so much for catching this!
-john


> ---
>  arch/avr32/kernel/time.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/arch/avr32/kernel/time.c b/arch/avr32/kernel/time.c
> index a047d69..668ed28 100644
> --- a/arch/avr32/kernel/time.c
> +++ b/arch/avr32/kernel/time.c
> @@ -112,7 +112,7 @@ static struct clock_event_device comparator = {
> 
>  void read_persistent_clock(struct timespec *ts)
>  {
> -	ts->tv.sec = mktime(2007, 1, 1, 0, 0, 0);
> +	ts->tv_sec = mktime(2007, 1, 1, 0, 0, 0);
>  	ts->tv_nsec = 0;
>  }
> 


