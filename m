Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757024Ab1KQMov (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 07:44:51 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55473 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752311Ab1KQMou convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 07:44:50 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Felipe Balbi" <balbi@ti.com>, Tonylijo <mail@tonylijo.in>
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH][RESEND] usb : gadget : usbstring : fix style problems
References: <1321527544.2367.29.camel@debian1.ic>
Date: Thu, 17 Nov 2011 13:44:47 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v43ccxbe3l0zgt@mpn-glaptop>
In-Reply-To: <1321527544.2367.29.camel@debian1.ic>
User-Agent: Opera Mail/11.52 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Nov 2011 11:59:04 +0100, Tonylijo <mail@tonylijo.in> wrote:
> @@ -84,8 +90,8 @@ fail:
>  }
>-/**
> - * usb_gadget_get_string - fill out a string descriptor
> +/*
> + * usb_gadget_get_string - fill out a string descriptor

Shouldn't that be usb_gadget_get_string() (ie. with parens)?

>   * @table: of c strings encoded using UTF-8
>   * @id: string id, from low byte of wValue in get string descriptor
>   * @buf: at least 256 bytes

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
