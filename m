Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756663Ab1KPMJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 07:09:32 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:54849 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756452Ab1KPMJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 07:09:31 -0500
Message-ID: <4EC3A7C3.8010802@mvista.com>
Date: Wed, 16 Nov 2011 16:08:35 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Tonylijo <mail@tonylijo.in>
CC: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] usb : gadget : usbstring : fix style problems
References: <1321418582.2443.4.camel@debian1.ic>
In-Reply-To: <1321418582.2443.4.camel@debian1.ic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 16-11-2011 8:43, Tonylijo wrote:

> Minor fixes for problems found by checkpatch.pl in usbstring.c.

> Signed-off-by: Tonylijo Jose<mail@tonylijo.in>
> ---
> diff --git a/drivers/usb/gadget/usbstring.c
> b/drivers/usb/gadget/usbstring.c
> index 58c4d37..2bdc56a 100644
> --- a/drivers/usb/gadget/usbstring.c
> +++ b/drivers/usb/gadget/usbstring.c
[...]
> @@ -102,17 +104,17 @@ fail:
>    * characters (which are also widely used in C strings).
>    */
>   int
> -usb_gadget_get_string (struct usb_gadget_strings *table, int id, u8
> *buf)
> +usb_gadget_get_string(struct usb_gadget_strings *table, int id, u8
> *buf)

    The patch was line-wrapped by your mailer. Seems easy to fix though...

> @@ -124,13 +126,13 @@ usb_gadget_get_string (struct usb_gadget_strings
> *table, int id, u8 *buf)
>   		return -EINVAL;
>
>   	/* string descriptors have length, tag, then UTF16-LE text */
> -	len = min ((size_t) 126, strlen (s->s));
> -	memset (buf + 2, 0, 2 * len);	/* zero all the bytes */
> +	len = min((size_t) 126, strlen(s->s));

    Worth converting to min_t() probably...

WBR, Sergei
