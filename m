Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603Ab2FLQRt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 12:17:49 -0400
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:44171 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753481Ab2FLQRq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 12:17:46 -0400
Message-ID: <4FD76B9B.3080100@xenotime.net>
Date: Tue, 12 Jun 2012 09:17:31 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Michal Nazarewicz <mnazarewicz@gmail.com>,
        Benoit Goby <benoit@android.com>, Mike Lockwood <lockwood@android.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 1/2 RESEND] staging: usb: gadget: Configurable Composite
 Gadget depends on BLOCK
References: <Pine.LNX.4.44L0.1206071646360.1185-100000@iolanthe.rowland.org> <1339405919-5845-1-git-send-email-andrzej.p@samsung.com>
In-Reply-To: <1339405919-5845-1-git-send-email-andrzej.p@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/2012 02:11 AM, Andrzej Pietrasiewicz wrote:

> Signed-off-by: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>


Acked-by: Randy Dunlap <rdunlap@xenotime.net>

Thanks.

> ---
>  drivers/staging/ccg/Kconfig |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/staging/ccg/Kconfig b/drivers/staging/ccg/Kconfig
> index ff05e52..1f00d70 100644
> --- a/drivers/staging/ccg/Kconfig
> +++ b/drivers/staging/ccg/Kconfig
> @@ -2,7 +2,7 @@ if USB_GADGET
>  
>  config USB_G_CCG
>  	tristate "Configurable Composite Gadget (STAGING)"
> -	depends on STAGING && !USB_ZERO && !USB_ZERO_HNPTEST && !USB_AUDIO && !GADGET_UAC1 && !USB_ETH && !USB_ETH_RNDIS && !USB_ETH_EEM && !USB_G_NCM && !USB_GADGETFS && !USB_FUNCTIONFS && !USB_FUNCTIONFS_ETH && !USB_FUNCTIONFS_RNDIS && !USB_FUNCTIONFS_GENERIC && !USB_FILE_STORAGE && !USB_FILE_STORAGE_TEST && !USB_MASS_STORAGE && !USB_G_SERIAL && !USB_MIDI_GADGET && !USB_G_PRINTER && !USB_CDC_COMPOSITE && !USB_G_NOKIA && !USB_G_ACM_MS && !USB_G_MULTI && !USB_G_MULTI_RNDIS && !USB_G_MULTI_CDC && !USB_G_HID && !USB_G_DBGP && !USB_G_WEBCAM
> +	depends on STAGING && BLOCK && !USB_ZERO && !USB_ZERO_HNPTEST && !USB_AUDIO && !GADGET_UAC1 && !USB_ETH && !USB_ETH_RNDIS && !USB_ETH_EEM && !USB_G_NCM && !USB_GADGETFS && !USB_FUNCTIONFS && !USB_FUNCTIONFS_ETH && !USB_FUNCTIONFS_RNDIS && !USB_FUNCTIONFS_GENERIC && !USB_FILE_STORAGE && !USB_FILE_STORAGE_TEST && !USB_MASS_STORAGE && !USB_G_SERIAL && !USB_MIDI_GADGET && !USB_G_PRINTER && !USB_CDC_COMPOSITE && !USB_G_NOKIA && !USB_G_ACM_MS && !USB_G_MULTI && !USB_G_MULTI_RNDIS && !USB_G_MULTI_CDC && !USB_G_HID && !USB_G_DBGP && !USB_G_WEBCAM
>  	help
>  	  The Configurable Composite Gadget supports multiple USB
>  	  functions: acm, mass storage, rndis and FunctionFS.



-- 
~Randy
