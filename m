Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755845Ab2ICILj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 04:11:39 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:38591 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755492Ab2ICILg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 04:11:36 -0400
Message-ID: <5044664C.5010508@ti.com>
Date: Mon, 03 Sep 2012 11:11:56 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120723 Thunderbird/14.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Samuel Ortiz <sameo@linux.intel.com>, NeilBrown <neilb@suse.de>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/2] mfd: twl: Move PWM driver to PWM framework
References: <1346582458-7890-1-git-send-email-thierry.reding@avionic-design.de>
In-Reply-To: <1346582458-7890-1-git-send-email-thierry.reding@avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/02/2012 01:40 PM, Thierry Reding wrote:
> Hi,
> 
> This mini series replaces the twl_has_*() macros by the equivalent
> standard IS_ENABLED() macro and moves the PWM driver to the PWM
> framework.
> 
> I'll take the second patch through the PWM tree but would like to have
> some Acked-bys from people that know and have the hardware and can
> verify that I haven't broken anything.

All looks good for me but I have one comment for patch 2.

> 
> Thierry
> 
> Thierry Reding (2):
>   mfd: twl: Replace twl_has_*() macros by IS_ENABLED()
>   pwm: Move TWL6030 PWM driver to PWM framework
> 
>  drivers/mfd/Kconfig       |  10 ---
>  drivers/mfd/Makefile      |   1 -
>  drivers/mfd/twl-core.c    | 124 ++++++++-----------------------
>  drivers/mfd/twl6030-pwm.c | 165 -----------------------------------------
>  drivers/pwm/Kconfig       |   9 +++
>  drivers/pwm/Makefile      |   1 +
>  drivers/pwm/pwm-twl6030.c | 184 ++++++++++++++++++++++++++++++++++++++++++++++
>  7 files changed, 226 insertions(+), 268 deletions(-)
>  delete mode 100644 drivers/mfd/twl6030-pwm.c
>  create mode 100644 drivers/pwm/pwm-twl6030.c
> 


-- 
Péter
