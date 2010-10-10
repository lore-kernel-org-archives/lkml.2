Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932252Ab0JJKeA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 06:34:00 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:61209 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932311Ab0JJKd6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 06:33:58 -0400
Message-ID: <4CB1962B.5000502@ru.mvista.com>
Date: Sun, 10 Oct 2010 14:32:11 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Tatyana Brokhman <tlinder@codeaurora.org>
CC: linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Matthew Wilcox <willy@linux.intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5] usb: usb3.0 ch9 definitions
References: <1286635573-30035-1-git-send-email-tlinder@codeaurora.org>
In-Reply-To: <1286635573-30035-1-git-send-email-tlinder@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 09-10-2010 18:46, Tatyana Brokhman wrote:

> Adding SuperSpeed usb definitions as defined by ch9 of the USB3.0 spec.
> This patch is a preparation for adding SuperSpeed support to the gadget
> framework.

> Signed-off-by: Tatyana Brokhman<tlinder@codeaurora.org>
> ---
>   include/linux/usb/ch9.h |   58 ++++++++++++++++++++++++++++++++++++++++++++++-
>   1 files changed, 57 insertions(+), 1 deletions(-)

> diff --git a/include/linux/usb/ch9.h b/include/linux/usb/ch9.h
> index da2ed77..fc5506f 100644
> --- a/include/linux/usb/ch9.h
> +++ b/include/linux/usb/ch9.h
[...]
> @@ -712,16 +728,56 @@ struct usb_wireless_cap_descriptor {	/* Ultra Wide Band */
>   	__u8  bReserved;
>   } __attribute__((packed));
>
> +/* USB 2.0 Extension descriptor */
>   #define	USB_CAP_TYPE_EXT		2
>
>   struct usb_ext_cap_descriptor {		/* Link Power Management */
>   	__u8  bLength;
>   	__u8  bDescriptorType;
>   	__u8  bDevCapabilityType;
> -	__u8  bmAttributes;
> +	__le32 bmAttributes;
>   #define USB_LPM_SUPPORT			(1<<  1)	/* supports LPM */
>   } __attribute__((packed));
>
> +#define USB_DT_USB_EXT_CAP_SIZE	7
> +
> +/*
> + * SuperSpeed USB Capability descriptor: Defines the set of SuperSpeed USB
> + * specific device level capabilities
> + */
> +#define		USB_SS_CAP_TYPE		3

    Too many tabs here.

> +struct usb_ss_cap_descriptor {		/* Link Power Management */

WBR, Sergei
