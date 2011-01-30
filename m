Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751627Ab1A3Gnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 01:43:49 -0500
Received: from outgoing.selfhost.de ([82.98.87.70]:50027 "EHLO
	outgoing.selfhost.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751062Ab1A3Gnt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 01:43:49 -0500
Message-ID: <4D4508A0.1080200@afaics.de>
Date: Sun, 30 Jan 2011 07:43:44 +0100
From: Harald Dunkel <harri@afaics.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101210 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: 2.6.37, reiserfs: Null pointer dereference at shutdown time
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi folks,

I got a kernel dump at umount time of a huge reiserfs partition.
It said

	Null pointer dereference at 0000000000000010
	IP: [ffffffffa01dc818] open_xa_dir+0x2d/0x1b0 [reiserfs]
	:

The config file and a photo with a complete stack trace can be
found on

	http://afaics.de/reiserfs_problem/

A reiserfsck of this partition showed a lot of files to sync due
to the missing umount, but no other problems.

Kernel is 2.6.37 (amd64). Please mail if I can help to track this
down.


Regards

Harri
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk1FCJsACgkQUTlbRTxpHjdOxQCeLWtJr7oF4kI9EK8SCOTJfXcC
0JYAnROFdXeRmGMucUxP8ZduVWU7/ctV
=F0b4
-----END PGP SIGNATURE-----
