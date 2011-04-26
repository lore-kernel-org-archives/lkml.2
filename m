Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757459Ab1DZQ0c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 12:26:32 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:55753 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757264Ab1DZQ01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 12:26:27 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6327"; a="87724424"
From: David Brown <davidb@codeaurora.org>
To: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
Cc: dwalker@fifo99.com, Andrew Morton <akpm@linux-foundation.org>,
        Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        linux-arm-msm-owner@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linux.walleij@linaro.org>,
        Thomas Glexiner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Andres Salomon <dilinger@queued.net>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PM8921 MFD V5 5/6] MAINTAINERS: Add patterns for pmic 8921 files to MSM subsystem
References: <1302039657-19395-1-git-send-email-adharmap@codeaurora.org>
	<1302039657-19395-6-git-send-email-adharmap@codeaurora.org>
Date: Tue, 26 Apr 2011 09:26:26 -0700
In-Reply-To: <1302039657-19395-6-git-send-email-adharmap@codeaurora.org>
	(Abhijeet Dharmapurikar's message of "Tue, 5 Apr 2011 14:40:56 -0700")
Message-ID: <8yay62x6kst.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 05 2011, Abhijeet Dharmapurikar wrote:

> Signed-off-by: Abhijeet Dharmapurikar <adharmap@codeaurora.org>
> ---
>  MAINTAINERS |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 6b4b9cd..b9db68b 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -916,6 +916,8 @@ F:	drivers/mmc/host/msm_sdcc.h
>  F:	drivers/tty/serial/msm_serial.h
>  F:	drivers/tty/serial/msm_serial.c
>  F:	drivers/platform/msm/
> +F:	drivers/*/pm8???-*
> +F:	include/linux/mfd/pm8xxx/
>  T:	git git://codeaurora.org/quic/kernel/davidb/linux-msm.git
>  S:	Maintained

Acked-by: David Brown <davidb@codeaurora.org>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
