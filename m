Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752664Ab2BEIt5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 03:49:57 -0500
Received: from out.selfhost.de ([82.98.82.95]:35115 "EHLO outgoing.selfhost.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751692Ab2BEIt5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 03:49:57 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Feb 2012 03:49:56 EST
Message-ID: <4F2E4120.3030506@afaics.de>
Date: Sun, 05 Feb 2012 09:43:12 +0100
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120202 Thunderbird/10.0
MIME-Version: 1.0
To: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: /proc/self/mounts in chroot vs lxc
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi folks,

AFAIK /proc/mounts (-> self/mounts) is supposed to replace
/etc/mtab. Problem is: In a chroot it contains too much
(invalid) information about the parent's mount points. It is
very hard to figure out which lines are correct.

For lxc there seems to be no such problem, so I wonder if it
would be possible to extend this scheme to chroot?

I am not sure if this is a kernel or libc issue. Any helpful
comment would be highly appreciated.


Regards

Harri
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8uQSAACgkQUTlbRTxpHjebAACcDv8p76s834XRmt24Abyi2lei
Bg4An2zTYIvKz8uD7iYZ3f46fymZ+Guk
=pYTm
-----END PGP SIGNATURE-----
