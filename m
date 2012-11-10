Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453Ab2KJW26 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Nov 2012 17:28:58 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:65042 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852Ab2KJW24 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Nov 2012 17:28:56 -0500
Message-ID: <509EBBDE.9020902@suse.cz>
Date: Sat, 10 Nov 2012 21:41:02 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Johan Hovold <jhovold@gmail.com>
CC: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] USB: mos7840: remove unused variable
References: <CAMgPeKUTpA+qn3TA+4xpRa4z_Y1E+6mk+_Xdom+ugdqCttL3aQ@mail.gmail.com>
In-Reply-To: <CAMgPeKUTpA+qn3TA+4xpRa4z_Y1E+6mk+_Xdom+ugdqCttL3aQ@mail.gmail.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/08/2012 06:28 PM, Johan Hovold wrote:
> Fix warning about unused variable introduced by commit e681b66f2e19fa
> ("USB: mos7840: remove invalid disconnect handling") upstream.
> 
> A subsequent fix which removed the disconnect function got rid of the
> warning but that one was only backported to v3.6.
> 
> Reported-by: Jiri Slaby <jslaby@suse.cz>

FWIW Looks good to me.

> Cc: stable <stable@vger.kernel.org>
> Signed-off-by: Johan Hovold <jhovold@gmail.com>
> ---
> 
> This patch against v3.4 also applies to v3.0 (and v3.2).
> 
> Thanks,
> Johan
> 
>  drivers/usb/serial/mos7840.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/usb/serial/mos7840.c b/drivers/usb/serial/mos7840.c
> index 0179d34..c854235 100644
> --- a/drivers/usb/serial/mos7840.c
> +++ b/drivers/usb/serial/mos7840.c
> @@ -2581,7 +2581,6 @@ error:
>  static void mos7840_disconnect(struct usb_serial *serial)
>  {
>  	int i;
> -	unsigned long flags;
>  	struct moschip_port *mos7840_port;
>  	dbg("%s", " disconnect :entering..........");
> 

thanks,
-- 
js
suse labs
