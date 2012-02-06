Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab2BFGdn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 01:33:43 -0500
Received: from out.selfhost.de ([82.98.82.95]:52867 "EHLO outgoing.selfhost.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751432Ab2BFGdm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 01:33:42 -0500
Message-ID: <4F2F7438.8040600@afaics.de>
Date: Mon, 06 Feb 2012 07:33:28 +0100
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120202 Thunderbird/10.0
MIME-Version: 1.0
To: Michael Tokarev <mjt@tls.msk.ru>
CC: Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: /proc/self/mounts in chroot vs lxc
References: <4F2E4120.3030506@afaics.de> <4F2E5B08.4010200@msgid.tls.msk.ru>
In-Reply-To: <4F2E5B08.4010200@msgid.tls.msk.ru>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 02/05/12 11:33, Michael Tokarev wrote:
> 
> But plain chroot does not create new namespace, the process inherits parent namespace, so there is no way to clean in up cleanly.
> 

If I do a chroot to /mnt, then there is no "/mnt" in /proc/self/mounts
within this environment. Instead I see yet another entry for '/'.
This certainly looks like something private.

Maybe it would be easier for everybody if /proc/mounts (without "/self")
could always show the "real" mount points at the top level? A bind mount
of /abc to /mnt/abc would appear as /mnt/abc in /proc/mounts at all levels.
I could live with that.



Regards

Harri
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk8vdDQACgkQUTlbRTxpHjcQOgCfXwKqVu7mAFTDctvcs1YAMQCq
FIsAn2UHiL+TncraqQffzdecN0eMadJy
=huO6
-----END PGP SIGNATURE-----
