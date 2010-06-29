Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab0F2Idb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 04:33:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48993 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab0F2Ida (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 04:33:30 -0400
Date: Tue, 29 Jun 2010 09:33:23 +0100
From: Eric B Munson <ebmunson@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: mingo@elte.hu, paulus@samba.org, acme@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org,
       Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH] Add munmap events to perf
Message-ID: <20100629083323.GA6917@us.ibm.com>
References: <1277748484-23882-1-git-send-email-ebmunson@us.ibm.com>
 <1277755486.3561.140.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="envbJBWh7q8WU6mo"
Content-Disposition: inline
In-Reply-To: <1277755486.3561.140.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--envbJBWh7q8WU6mo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Jun 2010, Peter Zijlstra wrote:

> On Mon, 2010-06-28 at 19:08 +0100, Eric B Munson wrote:
> > This patch adds a new software event for munmaps.  It will allows
> > users to profile changes to address space.  munmaps will be tracked
> > with mmaps.
>=20
> Why?
>=20

It is going to be used by a tool that will model memory usage over the
lifetime of a process.

--=20
Eric B Munson
IBM Linux Technology Center
ebmunson@us.ibm.com


--envbJBWh7q8WU6mo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwpr9MACgkQsnv9E83jkzrsjgCgvnV9nCZZgaVBWFU/vCaYpykw
bB4An3wpdTeiLG/jeYHggrKHv+WgFCtJ
=sVbb
-----END PGP SIGNATURE-----

--envbJBWh7q8WU6mo--
