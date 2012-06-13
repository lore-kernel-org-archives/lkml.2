Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705Ab2FMTS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 15:18:26 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:60381 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754655Ab2FMTSY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 15:18:24 -0400
X-Authenticated: #5108953
X-Provags-ID: V01U2FsdGVkX1/mQXN19VvmbYPctV58klaiW7n09DtJqTmheApwWD
	lzvX8hfk+Nu4Sf
Message-ID: <4FD8E77C.1090605@gmx.de>
Date: Wed, 13 Jun 2012 21:18:20 +0200
From: =?ISO-8859-1?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120606 Thunderbird/13.0
MIME-Version: 1.0
To: linux-pm@vger.kernel.org
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: suspend-to-disk issue with an external USB boot device
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can successfully boot from an external USB drive (detected as
/dev/sdb, the internal hard disk is always detected as /dev/sda).
Suspend-to-ram works fine. Suspend-to-disk looks ok during hibernation
phase. However when I wake up the system, then the hibernation isn't
detected. The only message I get is from the Gentoo init scripts:

swapon: /dev/sdb2: software suspend data detected. Rewriting the swap
signature.

I tried both my home-brewed kernel as well as initramfs kernel (created
with genkernel) - no luck.

Now I'm wondering where to start to find the root cause.
-- 
MfG/Sincerely
Toralf Förster
pgp finger print: 7B1A 07F4 EC82 0F90 D4C2 8936 872A E508 7DB6 9DA3

