Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab2B0LT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 06:19:26 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:49542 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753233Ab2B0LTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 06:19:24 -0500
X-Sasl-enc: yFpzO5aUT9c2pZGflZX1BFw+FeHo/xpUZObzGMIlMByW 1330341564
Message-ID: <4F4B66BA.5070007@imap.cc>
Date: Mon, 27 Feb 2012 12:19:22 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: Joe Perches <joe@perches.com>, LKML <linux-kernel@vger.kernel.org>,
        Hansjoerg Lipp <hjlipp@web.de>,
        gigaset307x-common@lists.sourceforge.net,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: "whitespace coding style cleanup" broke coding style
References: <4F4B45F6.4090706@suse.cz>
In-Reply-To: <4F4B45F6.4090706@suse.cz>
X-Enigmail-Version: 1.3.3
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 27.02.2012 09:59, schrieb Jiri Slaby:
> commit 475be4d85a274d0961593db41cf85689db1d583c Author: Joe Perches
> <joe@perches.com> Date:   Sun Feb 19 19:52:38 2012 -0800
> 
> isdn: whitespace coding style cleanup
> 
> isdn source code uses a not-current coding style. ... Done with
> emacs and some scripts and some typing. ... ---
> a/drivers/isdn/gigaset/interface.c +++
> b/drivers/isdn/gigaset/interface.c ... @@ -680,9 +680,9 @@ void
> gigaset_if_initdriver(struct gigaset_driver *drv, const char
> *procname, goto enomem;
> 
> tty->magic =            TTY_DRIVER_MAGIC, -       tty->type =
> TTY_DRIVER_TYPE_SERIAL, -       tty->subtype =
> SERIAL_TYPE_NORMAL, -       tty->flags =
> TTY_DRIVER_REAL_RAW | TTY_DRIVER_DYNAMIC_DEV; +
> tty->type =             TTY_DRIVER_TYPE_SERIAL, +
> tty->subtype =          SERIAL_TYPE_NORMAL, +
> tty->flags =            TTY_DRIVER_REAL_RAW | 
> TTY_DRIVER_DYNAMIC_DEV;
> 
> Hmm, please, fix your scripts or emacs!
> 
> Through which tree did this get in?

That's the first I see of this patch.
It neither came through LKML nor did I get a CC.
For all I know, this didn't get in.
It isn't in http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git
anyway.

Regards,
Tilman

- -- 
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk9LZroACgkQMdB4Whm86/ndbQCeLQM0kHgzLSbexyF5qiH+bkq/
b+YAn0cM5VEzsoPVW3iQYYzbeByHyEFN
=AcbN
-----END PGP SIGNATURE-----
