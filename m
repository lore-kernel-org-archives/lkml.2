Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758641Ab2C2BT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 21:19:58 -0400
Received: from oproxy9.bluehost.com ([69.89.24.6]:56414 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758170Ab2C2BTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 21:19:52 -0400
Message-ID: <4F73B8B8.8000609@xenotime.net>
Date: Wed, 28 Mar 2012 18:19:52 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Rafal Kapela <raf.kapela@gmail.com>
CC: gregkh@linuxfoundation.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation:"the the" in ABI/stable/sysfs-driver-usb-usbtmc
 Documentation misspelling
References: <1332437749-25766-1-git-send-email-raf.kapela@gmail.com>
In-Reply-To: <1332437749-25766-1-git-send-email-raf.kapela@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/22/2012 10:35 AM, Rafal Kapela wrote:

> Signed-off-by: Rafal Kapela <raf.kapela@gmail.com>


Applied, thanks.


> ---
>  Documentation/ABI/stable/sysfs-driver-usb-usbtmc |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/Documentation/ABI/stable/sysfs-driver-usb-usbtmc b/Documentation/ABI/stable/sysfs-driver-usb-usbtmc
> index 23a43b8..2a7f9a0 100644
> --- a/Documentation/ABI/stable/sysfs-driver-usb-usbtmc
> +++ b/Documentation/ABI/stable/sysfs-driver-usb-usbtmc
> @@ -55,7 +55,7 @@ What:		/sys/bus/usb/drivers/usbtmc/devices/*/auto_abort
>  Date:		August 2008
>  Contact:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>  Description:
> -		This file determines if the the transaction of the USB TMC
> +		This file determines if the transaction of the USB TMC
>  		device is to be automatically aborted if there is any error.
>  		For more details about this, please see the document,
>  		"Universal Serial Bus Test and Measurement Class Specification



-- 
~Randy
