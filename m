Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932107Ab2CERIF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 12:08:05 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:57236 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756766Ab2CERIC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 12:08:02 -0500
X-Sasl-enc: XwV3CCeuSGbZovDmplx+GjLJqLF5/+zctVV7Q2uq8LOw 1330967282
Message-ID: <4F54F2F0.8090909@imap.cc>
Date: Mon, 05 Mar 2012 18:08:00 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.2.27) Gecko/20120215 SUSE/3.1.19 Thunderbird/3.1.19
MIME-Version: 1.0
To: Jiri Slaby <jslaby@suse.cz>
CC: gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com, Hansjoerg Lipp <hjlipp@web.de>,
        gigaset307x-common@lists.sourceforge.net
Subject: Re: [PATCH 68/68] TTY: isdn/gigaset, use tty_port
References: <1330955575-26641-1-git-send-email-jslaby@suse.cz> <1330955575-26641-69-git-send-email-jslaby@suse.cz>
In-Reply-To: <1330955575-26641-69-git-send-email-jslaby@suse.cz>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Am 05.03.2012 14:52, schrieb Jiri Slaby:
> Let us port the code to use tty_port. We now use open_count and tty
> from there. This allows us also to use tty_port_tty_set with tty
> refcounting instead of hand-written locking and logic.
> 
> Note that tty and open_count are no longer protected by cs->lock. It is
> protected by tty_port->lock. But since all the places where they were
> used are now switched to the helpers, we are fine.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Hansjoerg Lipp <hjlipp@web.de>
> Cc: Tilman Schmidt <tilman@imap.cc>
> Cc: gigaset307x-common@lists.sourceforge.net

Very nice. Thanks!

Acked-by: Tilman Schmidt <tilman@imap.cc>

- -- 
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Ungeöffnet mindestens haltbar bis: (siehe Rückseite)
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAk9U8vAACgkQQ3+did9BuFv8RACeLMRSUGhjotg0il1LtWqtfrzR
sakAn0LJr66dYyUXteH44p5+KFQuS5v9
=Is+Q
-----END PGP SIGNATURE-----
