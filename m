Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756716Ab2FPLMK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 07:12:10 -0400
Received: from out.selfhost.de ([82.98.82.95]:54119 "EHLO outgoing.selfhost.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756351Ab2FPLMI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 07:12:08 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sat, 16 Jun 2012 07:12:07 EDT
Message-ID: <4FDC6874.4070106@afaics.de>
Date: Sat, 16 Jun 2012 13:05:24 +0200
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120607 Thunderbird/13.0
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-console@vger.kernel.org
Subject: wishlist: vnc framebuffer device?
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi folks,

To make a headless system "less headless", would it be possible
to integrate a vnc framebuffer device into the kernel?

The idea is to have a vnc server instead of a local screen and
keyboard to show the boot output and to provide a console login
on /dev/tty{1..6}. It would be pretty similar to qemu. No need
for fancy graphics, of course. The IP address might either be
obtained using DHCP, or it might use an IP address/netmask
given on the kernel command line.

I understand that authentication might be an issue here.

Hopefully this isn't one of the oh-no-not-again questions. I
haven't seen it mentioned on the kernel or linux-console
mailing lists before.


Regards

Harri
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/caG4ACgkQUTlbRTxpHjf8EwCZAZ0H17WYyEwJB3QgCNjazY2O
3NMAn2e0dJa3sbiZr33nY11m1g0zm0j3
=MANA
-----END PGP SIGNATURE-----
