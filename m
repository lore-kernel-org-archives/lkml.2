Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab2B0Led (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 06:34:33 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:59737 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753793Ab2B0Lec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 06:34:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.14.198.72 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F4B6A44.4020309@suse.cz>
Date: Mon, 27 Feb 2012 12:34:28 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120222 Thunderbird/11.0
MIME-Version: 1.0
To: Tilman Schmidt <tilman@imap.cc>
CC: Jiri Slaby <jirislaby@gmail.com>, Joe Perches <joe@perches.com>,
        LKML <linux-kernel@vger.kernel.org>, Hansjoerg Lipp <hjlipp@web.de>,
        gigaset307x-common@lists.sourceforge.net,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: "whitespace coding style cleanup" broke coding style
References: <4F4B45F6.4090706@suse.cz> <4F4B66BA.5070007@imap.cc>
In-Reply-To: <4F4B66BA.5070007@imap.cc>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/27/2012 12:19 PM, Tilman Schmidt wrote:
> Am 27.02.2012 09:59, schrieb Jiri Slaby:
>> commit 475be4d85a274d0961593db41cf85689db1d583c Author: Joe Perches
>> <joe@perches.com>  Date:   Sun Feb 19 19:52:38 2012 -0800
>>
>> isdn: whitespace coding style cleanup
>>
>> isdn source code uses a not-current coding style. ... Done with
>> emacs and some scripts and some typing. ... ---
>> a/drivers/isdn/gigaset/interface.c +++
>> b/drivers/isdn/gigaset/interface.c ... @@ -680,9 +680,9 @@ void
>> gigaset_if_initdriver(struct gigaset_driver *drv, const char
>> *procname, goto enomem;
>>
>> tty->magic =            TTY_DRIVER_MAGIC, -       tty->type =
>> TTY_DRIVER_TYPE_SERIAL, -       tty->subtype =
>> SERIAL_TYPE_NORMAL, -       tty->flags =
>> TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV; +
>> tty->type =             TTY_DRIVER_TYPE_SERIAL, +
>> tty->subtype =          SERIAL_TYPE_NORMAL, +
>> tty->flags =            TTY_DRIVER_REAL_RAW |
>> TTY_DRIVER_DYNAMIC_DEV;
>>
>> Hmm, please, fix your scripts or emacs!
>>
>> Through which tree did this get in?
>
> That's the first I see of this patch.
> It neither came through LKML nor did I get a CC.
> For all I know, this didn't get in.
> It isn't in http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git
> anyway.

By "in" I meant "in -next". gitk suggests through davem's tree.

It collided with my local patches, this is how I spotted it...

thanks,
-- 
js
suse labs
