Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab0DUQne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 12:43:34 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:65249 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755926Ab0DUQnd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 12:43:33 -0400
Date: Wed, 21 Apr 2010 18:43:44 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 2/2] Mass storage gadget: Handle eject request
In-reply-to: <1271864304-4279-2-git-send-email-fabien.chouteau@gmail.com>
To: fabien.chouteau@gmail.com, linux-usb@vger.kernel.org
Cc: Fabien Chouteau <fabien.chouteau@barco.com>,
       David Brownell <dbrownell@users.sourceforge.net>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Peter Korsgaard <jacmet@sunsite.dk>, linux-kernel@vger.kernel.org
Message-id: <op.vbit26d87p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <1271864304-4279-1-git-send-email-fabien.chouteau@gmail.com>
 <1271864304-4279-2-git-send-email-fabien.chouteau@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Apr 2010 17:38:22 +0200, <fabien.chouteau@gmail.com> wrote:
> From: Fabien Chouteau <fabien.chouteau@barco.com>
>
>
> Signed-off-by: Fabien Chouteau <fabien.chouteau@barco.com>

Commit message missing, in both patches.  It should contain some
details on what the patch does and how this can be used.

> @@ -2412,7 +2451,6 @@ static void fsg_disable(struct usb_function *f)
>  	raise_exception(fsg->common, FSG_STATE_CONFIG_CHANGE);
>  }
>-

This is not important, but if you are going to resend the patch,
how about not deleting this line?

>  /*-------------------------------------------------------------------------*/
> static void handle_exception(struct fsg_common *common)
> @@ -2641,7 +2679,7 @@ static int fsg_main_thread(void *common_)
>  /* Write permission is checked per LUN in store_*() functions. */
>  static DEVICE_ATTR(ro, 0644, fsg_show_ro, fsg_store_ro);
>  static DEVICE_ATTR(file, 0644, fsg_show_file, fsg_store_file);
> -
> +static DEVICE_ATTR(ejected, 0444, fsg_show_ejected, NULL);

Same here.

Otherwise, both patches look fine to me.

-- 
Best regards,                                           _     _
  .o. | Liege of Serenely Enlightened Majesty of       o' \,=./ `o
  ..o | Computer Science,  Michał "mina86" Nazarewicz     (o o)
  ooo +---[mina86@mina86.com]---[mina86@jabber.org]---ooO--(_)--Ooo--
