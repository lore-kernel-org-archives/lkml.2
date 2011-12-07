Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758052Ab1LGUw3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 15:52:29 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:40822 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757997Ab1LGUw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 15:52:28 -0500
Message-ID: <4EDFDFF4.1090307@xenotime.net>
Date: Wed, 07 Dec 2011 13:51:48 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
Organization: YPO4
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@googlemail.com>
CC: linux-input@vger.kernel.org, linux-next@vger.kernel.org, jkosina@suse.cz,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] HID: wiimote: Select INPUT_FF_MEMLESS
References: <4EDFD23D.4030703@xenotime.net> <1323290039-28073-1-git-send-email-dh.herrmann@googlemail.com>
In-Reply-To: <1323290039-28073-1-git-send-email-dh.herrmann@googlemail.com>
Content-Type: text/plain; charset=windows-1250
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/07/2011 12:33 PM, David Herrmann wrote:
> We depend on memless force-feedback support, therefore correctly select the
> related config options.
> 
> Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>

Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
> Hi Randy
> 
> Thanks for reporting this. This patch should fix this. I don't know whether such
> fixes belong to stable tree, if they do, Jiri could you CC stable when applying
> it?
> 
> Cheers
> David
> 
>  drivers/hid/Kconfig |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/hid/Kconfig b/drivers/hid/Kconfig
> index edf2b2b..dae04a0 100644
> --- a/drivers/hid/Kconfig
> +++ b/drivers/hid/Kconfig
> @@ -591,6 +591,7 @@ config HID_WIIMOTE
>  	depends on BT_HIDP
>  	depends on LEDS_CLASS
>  	select POWER_SUPPLY
> +	select INPUT_FF_MEMLESS
>  	---help---
>  	Support for the Nintendo Wii Remote bluetooth device.
>  


-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
