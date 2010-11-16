Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082Ab0KPFU3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 00:20:29 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:57577 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab0KPFU2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 00:20:28 -0500
Date: Tue, 16 Nov 2010 14:20:27 +0900
From: Norbert Preining <preining@logic.at>
To: linux-kernel@vger.kernel.org
Subject: /dev/sda disappearing with SYFS_DEPRECATED?
Message-ID: <20101116052027.GB24410@gamma.logic.tuwien.ac.at>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

(please Cc)

I just changed my kernel config slightly to activate some DEPRECATED
configs and alas, the change was interesting, suddenly there
was no /dev/sda shown anymore.

Userspace remain completely the same (debian/sid up2date).

The only changes I made in the .config file was:
-# CONFIG_SYSFS_DEPRECATED is not set
+CONFIG_SYSFS_DEPRECATED=y
+CONFIG_SYSFS_DEPRECATED_V2=y

-CONFIG_NFSD_DEPRECATED=y
+# CONFIG_NFSD_DEPRECATED is not set

and this made the /dev/sda* entries disappear.

Is that to be expected?

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
YESNABY (n.)
A 'yes, maybe' which means 'no'.
			--- Douglas Adams, The Meaning of Liff
