Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752202Ab2AWRRI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 12:17:08 -0500
Received: from home.keithp.com ([63.227.221.253]:47766 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750757Ab2AWRRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 12:17:06 -0500
From: Keith Packard <keithp@keithp.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-bluetooth@vger.kernel.org
Subject: Re: [PATCH] Regression: Revert "Bluetooth: use buffer priority to mark URB_ISO_ASAP flag"
In-Reply-To: <Pine.LNX.4.44L0.1201231019580.1372-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1201231019580.1372-100000@iolanthe.rowland.org>
User-Agent: Notmuch/0.11 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Mon, 23 Jan 2012 09:16:47 -0800
Message-ID: <864nvmuyo0.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jan 2012 10:23:14 -0500 (EST), Alan Stern <stern@rowland.harvard=
.edu> wrote:

> Well, if the DEBUG code never changed any behaviors at all, it would be=20
> pretty useless, wouldn't it?

A WARN_ON would have been sufficient to catch attention without breaking
an otherwise working system.

This is certainly the first time I've ever encountered DEBUG code that
did anything more than print out information to help developers debug
stuff...

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTx2V/zYtFsjWk68qAQjT+g/+O+tHlZaPrMe+7iYWk/XlGPnvwwqiRUr1
6qw/2RXYHb+ngqpARfG+oMy7qEHxwGZKdMJZf9DUUaC7gTY1bAgDyERYCQOIGPOp
Ms6FlQ2wuS0aQ8ryh2pvNghu3sg1G+/TAsty16ZrYoerBZ0qlLRXRKBjlrriZcnB
4vg6OsZZmDqqQS8/7yoAsLL6CoJFq2qfO4JRDy01zkdalKaOMUYWw8cXQx9Bj6mt
Z4GrqrRv764FiQrJiAjFGuNF2eFCn9Jn07RagpT599mJogyxy0vhv8KoIu/PiRnb
Re3vlcUXknfypuMRAifx+I/epgo3GgFo6iPXevfYUld8pqy/qmvl6vWzyZoc/bTH
vV7DhkuyRGQ1Y7V0bGubDuh9I/NmoUthlF5+59MJvzT5bqyaVnzyzFNhXoFVPqxG
GXnfHhDUk0nxtNB6jOJI1M/TJuA57fGpLScy52H/QmdY60hPGtu47pJpTeyKkNOW
fHO0B7CyBcn6Z2dt1E8mO4CxcSCEvKb6qsJRw/0qQ/rr2rlO49aWUG2H1oo40WCV
3lmGU8nTrvOm8Jrqt1dNkJm3PUMMRNuGlOB5NG5oVDLdVta2GM4RSHXNmMzrZ0Xj
jvJPlOL/1YI07JSk5R32BQRV2/ff4dLNwqbYTihYJsWTrXFgFqmABLRCQk57DuXu
U6FsJnlOnAU=
=pAj7
-----END PGP SIGNATURE-----
--=-=-=--
