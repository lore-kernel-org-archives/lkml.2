Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751523Ab1LJTkE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Dec 2011 14:40:04 -0500
Received: from mognix.dark-green.com ([88.116.226.179]:59800 "EHLO
	mognix.dark-green.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991Ab1LJTkA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Dec 2011 14:40:00 -0500
X-Greylist: delayed 301 seconds by postgrey-1.27 at vger.kernel.org; Sat, 10 Dec 2011 14:40:00 EST
Message-ID: <4EE3B5AD.6060505@dark-green.com>
Date: Sat, 10 Dec 2011 20:40:29 +0100
From: gimli <gimli@dark-green.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111108 Thunderbird/8.0
MIME-Version: 1.0
To: Darren Hart <dvhart@linux.intel.com>
CC: "lkml, " <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [PATCH] efifb: Update documentation to include generic EFI 1.1
 and UEFI 2.0 platforms
References: <4EE112A8.5030006@linux.intel.com>
In-Reply-To: <4EE112A8.5030006@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-12-08 20:40, Darren Hart wrote:
> According to the Kconfig help, efifb supports EFI 1.1 and UEFI 2.0 platforms
> in addition to the Intel based Macs. I have Atom development platforms that
> require CONFIG_FB_EFI for kernel output to the display console. I have left
> the Mac kernel parameters alone as I do not have hardware to test it.
>
> Signed-off-by: Darren Hart<dvhart@linux.intel.com>
> CC: H. Peter Anvin<hpa@zytor.com>
> CC: Matt Fleming<matt.fleming@linux.intel.com>
> CC: Edgar Hucek<gimli@dark-green.com>
> ---
>   Documentation/fb/efifb.txt |   12 ++++++++----
>   1 files changed, 8 insertions(+), 4 deletions(-)
>
> diff --git a/Documentation/fb/efifb.txt b/Documentation/fb/efifb.txt
> index a59916c..7cb9a62 100644
> --- a/Documentation/fb/efifb.txt
> +++ b/Documentation/fb/efifb.txt
> @@ -2,12 +2,15 @@
>   What is efifb?
>   ===============
>
> -This is a generic EFI platform driver for Intel based Apple computers.
> -efifb is only for EFI booted Intel Macs.
> +This is a generic EFI platform driver for Intel based Apple computers and
> +platforms with EFI 1.10 or UEFI 2.0 firmware. Select CONFIG_FB_EFI to add
> +support for using the EFI framebuffer as your console.
>
>   Supported Hardware
>   ==================
>
> +EFI 1.10 platforms
> +UEFI 2.0 platforms
>   iMac 17"/20"
>   Macbook
>   Macbook Pro 15"/17"
> @@ -16,8 +19,9 @@ MacMini
>   How to use it?
>   ==============
>
> -efifb does not have any kind of autodetection of your machine.
> -You have to add the following kernel parameters in your elilo.conf:
> +efifb will autodetect the framebuffer on some machines, for others
> +you will have to add the appropriate kernel parameters to your boot
> +loader configuration. For example:
>   	Macbook :
>   		video=efifb:macbook
>   	MacMini :

Looks ok to me :

Acked-by: Edgar Hucek <gimli@dark-green.com>

Please forward it to the LKML.
