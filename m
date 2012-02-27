Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076Ab2B0Qwc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 11:52:32 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:34930 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753125Ab2B0Qwb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 11:52:31 -0500
Message-ID: <1330361549.9942.7.camel@joe2Laptop>
Subject: Re: "whitespace coding style cleanup" broke coding style
From: Joe Perches <joe@perches.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, Hansjoerg Lipp <hjlipp@web.de>,
        Tilman Schmidt <tilman@imap.cc>,
        gigaset307x-common@lists.sourceforge.net,
        Jiri Slaby <jirislaby@gmail.com>
Date: Mon, 27 Feb 2012 08:52:29 -0800
In-Reply-To: <4F4B45F6.4090706@suse.cz>
References: <4F4B45F6.4090706@suse.cz>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-27 at 09:59 +0100, Jiri Slaby wrote:
> commit 475be4d85a274d0961593db41cf85689db1d583c
> Author: Joe Perches <joe@perches.com>
> Date:   Sun Feb 19 19:52:38 2012 -0800
> 
>      isdn: whitespace coding style cleanup
> 
>      isdn source code uses a not-current coding style.
> ...
>      Done with emacs and some scripts and some typing.
> ...
> --- a/drivers/isdn/gigaset/interface.c
> +++ b/drivers/isdn/gigaset/interface.c
> ...
> @@ -680,9 +680,9 @@ void gigaset_if_initdriver(struct gigaset_driver 
> *drv, const
>   char *procname,
>                  goto enomem;
> 
>          tty->magic =            TTY_DRIVER_MAGIC,
> -       tty->type =             TTY_DRIVER_TYPE_SERIAL,
> -       tty->subtype =          SERIAL_TYPE_NORMAL,
> -       tty->flags =            TTY_DRIVER_REAL_RAW | 
> TTY_DRIVER_DYNAMIC_DEV;
> +               tty->type =             TTY_DRIVER_TYPE_SERIAL,
> +               tty->subtype =          SERIAL_TYPE_NORMAL,
> +               tty->flags =            TTY_DRIVER_REAL_RAW | 
> TTY_DRIVER_DYNAMIC_DEV;
> 
> Hmm, please, fix your scripts or emacs!

Hi Jiri.

I'm not fixing emacs.

Notice that the code improperly uses commas and
not semicolons for line terminations like the
lines immediately above and below it.

btw:  Your copy/paste lost the tab indents.

The emacs pass was not perfect, nor was it
intended to be perfect.  There are _way_
too many coding style defects in isdn for
that.

It was a first pass and an overall improvement.

"It's quite a bit more like what passes
for the current kernel coding style though."

> Through which tree did this get in?

net-next

> thanks,

I'm working on improving the logging style
in isdn and will submit more patches soonish.

cheers, Joe

