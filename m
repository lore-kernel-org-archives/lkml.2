Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932866Ab1IBBDL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 21:03:11 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:48554 "EHLO
	rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932747Ab1IBBDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 21:03:08 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.13 with qID p8212pAF005265
X-BOX-Message-Id: p8212pAF005265
Message-ID: <4E602B3B.20703@realsil.com.cn>
Date: Fri, 2 Sep 2011 09:02:51 +0800
From: edwin_rong <edwin_rong@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Vincent Palatin <vpalatin@chromium.org>
CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "usb-storage@lists.one-eyed-alien.net" 
	<usb-storage@lists.one-eyed-alien.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mandeep Singh Baines <msb@chromium.org>,
        =?UTF-8?B?546L54Kc?= <wei_wang@realsil.com.cn>,
        Olof Johansson <olofj@chromium.org>
Subject: Re: [PATCH] usb-storage: fix realtek cr configuration
References: <1314911115-32619-1-git-send-email-vpalatin@chromium.org>
In-Reply-To: <1314911115-32619-1-git-send-email-vpalatin@chromium.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Vincent,

Thanks for the fix.

BRs
Edwin

On 09/02/2011 05:05 AM, Vincent Palatin wrote:
> A typo in the configuration variable name prevents from activating the
> USB autosuspend on the device.
>
> Signed-off-by: Vincent Palatin<vpalatin@chromium.org>
> ---
>   drivers/usb/storage/Kconfig |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/usb/storage/Kconfig b/drivers/usb/storage/Kconfig
> index bedc4b9..fe2d803 100644
> --- a/drivers/usb/storage/Kconfig
> +++ b/drivers/usb/storage/Kconfig
> @@ -42,7 +42,7 @@ config USB_STORAGE_REALTEK
>
>   config REALTEK_AUTOPM
>   	bool "Realtek Card Reader autosuspend support"
> -	depends on USB_STORAGE_REALTEK&&  CONFIG_PM_RUNTIME
> +	depends on USB_STORAGE_REALTEK&&  PM_RUNTIME
>   	default y
>
>   config USB_STORAGE_DATAFAB

