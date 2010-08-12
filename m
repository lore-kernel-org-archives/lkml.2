Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758838Ab0HLRZH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 13:25:07 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:6494 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758654Ab0HLRZC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 13:25:02 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6072"; a="50796501"
Message-ID: <4C642E6D.6000908@codeaurora.org>
Date: Thu, 12 Aug 2010 10:25:01 -0700
From: Stepan Moskovchenko <stepanm@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Neil Leeder <nleeder@codeaurora.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-input@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Horace Fu <horace.fu@quantatw.com>,
        Mandeep Singh Baines <msb@chromium.org>
Subject: Re: [PATCH v2] input: mouse: add qci touchpad driver
References: <1281631760-15589-1-git-send-email-nleeder@codeaurora.org>
In-Reply-To: <1281631760-15589-1-git-send-email-nleeder@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 8/12/2010 9:49 AM, Neil Leeder wrote:
> This driver is for the QCI trackpad used on Quanta smartbooks
>
> Signed-off-by: Horace Fu<horace.fu@quantatw.com>
> Signed-off-by: Mandeep Singh Baines<msb@chromium.org>
> [nleeder@codeaurora.org: cleanup i2c calls, address review comments etc]
> Signed-off-by: Neil Leeder<nleeder@codeaurora.org>
> ---
>   drivers/input/mouse/Kconfig        |   12 ++
>   drivers/input/mouse/Makefile       |    1 +
>   drivers/input/mouse/qci_touchpad.c |  270 ++++++++++++++++++++++++++++++++++++
>   include/linux/input/qci_touchpad.h |   25 ++++
>   4 files changed, 308 insertions(+), 0 deletions(-)
>   create mode 100644 drivers/input/mouse/qci_touchpad.c
>   create mode 100644 include/linux/input/qci_touchpad.h
>
> diff --git a/drivers/input/mouse/Kconfig b/drivers/input/mouse/Kconfig
> index c714ca2..32a88b4 100644
> --- a/drivers/input/mouse/Kconfig
> +++ b/drivers/input/mouse/Kconfig
> @@ -303,6 +303,18 @@ config MOUSE_MAPLE
>   	  To compile this driver as a module choose M here: the module will be
>   	  called maplemouse.
>
> +config MOUSE_QCITP
> +	tristate "Quanta Computer Inc. Touchpad"
> +	depends on I2C
> +	help
> +	  This driver supports the touchpad on Quanta smartbook devices.
> +
> +	  Say Y here if you have a Quanta-based smartboot or notepad
Sorry, very minor point - do you mean "smartbook" here?

A lot of machines are made by Quanta. Should this be given a description 
/ option name that is more specific, ie, "Quanta [chip name] Touchpad" 
or even "Quanta I2C Touchpad" ?  What you have might be fine, however...

Steve

