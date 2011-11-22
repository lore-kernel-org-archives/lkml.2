Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab1KVR4B (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 12:56:01 -0500
Received: from home.keithp.com ([63.227.221.253]:34338 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752796Ab1KVR4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 12:56:00 -0500
From: Keith Packard <keithp@keithp.com>
To: Meelis Roos <mroos@linux.ee>, David Woodhouse <dwmw2@infradead.org>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Bisected regression: hang on i915 between 3.1.0-rc9 and 3.1.0
In-Reply-To: <alpine.SOC.1.00.1111221306410.8925@math.ut.ee>
References: <alpine.SOC.1.00.1111221207090.6490@math.ut.ee> <alpine.SOC.1.00.1111221306410.8925@math.ut.ee>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Tue, 22 Nov 2011 09:56:01 -0800
Message-ID: <86vcqcf3da.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Nov 2011 13:08:06 +0200 (EET), Meelis Roos <mroos@linux.ee> wrot=
e:

> > 3.0 worked fine, 3.1-rc9 worked fine, I think -rc10 too. 3.1 release=20
> > hangs in random places while using X.

Do you have VT-d enabled in the BIOS?

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTsviMTYtFsjWk68qAQidOg/9EMWlxmaylqkZi2d+5JQq5ORFeMxbnvXO
TTI3FcDy6rpyKet/vtwsjnMpsLoiJQpYVd9rhrlarMJWWdtz88jh3S1fHaZoJPZI
xBPPxQgkTXUZM0TDhiAJE+E172N3j+LvdZMcYR5qcxXeW6kOJKC65/qsOqKj66zK
hjcx73UZBqKxYmMkt18dPaSLeiB5h0mmz1wsyf2ngzZ+ky9a9bBv5oM11yk6YWpO
NgDcTQtjBlG10/Uo5Mba+fwj/lEmQgDYW6sTsdV7N5m/wD3a4P4+8sv82LThoCcE
l7tJfZeQ+FJeFvdKZbjEOujtRLLRz5WlkWCj0VqozpDjXOI9RMPKPp/tSj3G5EmC
e2UZtAYY5XIr6q7tsE6+9Co4rYUQcYQbc1xBriGBnsocryhh4+o1mY1FxZv8V6Fq
MXC+3VgIiC4NNHX4OHOVzV1agS1Qi8TExuym9pHqtz7hyQeyxzsdSEpmBxyq+8Ve
V5Xxt1A/j8HyPLjAULHk6E2KIn4pfJ9y4aymV2wd2ebeFDFGuxGWAV+G23mKOlsy
+HSbBUjIs5UoSomYsjwEUj+1uiI0K94uu5cwWZTd2oPnzZQpvyRtiphjcPBuUR2x
NNl4BKLQ3vhJ00PHiDItI0PCmX3CMHFYur721UIa1p3lsh4PIqbVWhbkToaNMG+0
fOSWYMQXgv4=
=ePvA
-----END PGP SIGNATURE-----
--=-=-=--
