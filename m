Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751860Ab2IAGkI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 02:40:08 -0400
Received: from ext190.halfdog.net ([88.116.147.190]:51068 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751350Ab2IAGkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 02:40:06 -0400
Message-ID: <5041AD8C.1040606@halfdog.net>
Date: Sat, 01 Sep 2012 06:39:08 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Firefox/17.0 SeaMonkey/2.14a1
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Software interrupt 0x8 guest crash from userspace: virtualbox
 emulation or guest kernel bug?
References: <502EAB4D.90807@halfdog.net>
In-Reply-To: <502EAB4D.90807@halfdog.net>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

halfdog wrote:
> I have observed a strange guest kernel crash in virtualbox and are 
> currently trying to understand it. Since I have no real 32-bit
> Intel platform any more, I cannot verify that this crash would
> happen on native 32bit also, so perhaps someone could check that.
> ...

For the records: no checks needed any more, root cause of issue
already found.

- -- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAlBBrXEACgkQxFmThv7tq+6JHQCfaC1tCY2iLFcmoVwtA0UUZXpx
5TcAn1KhhpvgkaLGQ80AlErXzv6bN8SJ
=uJvv
-----END PGP SIGNATURE-----
