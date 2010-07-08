Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab0GHOwS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 10:52:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34280 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755403Ab0GHOwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 10:52:16 -0400
Date: Thu, 8 Jul 2010 15:44:07 +0100
From: Eric B Munson <ebmunson@us.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Eric B Munson <emunson@mgebm.net>, akpm@linux-foundation.org,
       mingo@redhat.com, hugh.dickins@tiscali.co.uk, riel@redhat.com,
       linux-kernel@vger.kernel.org, linux-mm@kvack.org, anton@samba.org
Subject: Re: [PATCH] Add trace event for munmap
Message-ID: <20100708144407.GA8141@us.ibm.com>
References: <1278597931-26855-1-git-send-email-emunson@mgebm.net>
 <1278598955.1900.152.camel@laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bg08WKrSYDhXBjb5"
Content-Disposition: inline
In-Reply-To: <1278598955.1900.152.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 08 Jul 2010, Peter Zijlstra wrote:

> On Thu, 2010-07-08 at 15:05 +0100, Eric B Munson wrote:
> > This patch adds a trace event for munmap which will record the starting
> > address of the unmapped area and the length of the umapped area.  This
> > event will be used for modeling memory usage.
>=20
> Does it make sense to couple this with a mmap()/mremap()/brk()
> tracepoint?
>=20

We were using the mmap information collected by perf, but I think
those might also be useful so I will send a followup patch to add
them.

--=20
Eric B Munson
IBM Linux Technology Center
emunson@mgebm.net


--bg08WKrSYDhXBjb5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkw15DcACgkQsnv9E83jkzqeGwCgoFBc6kS51O01xydGT2QyVSUt
DdQAoPPcppaW7XQAUPoE9pPjmFzKah0H
=xsXW
-----END PGP SIGNATURE-----

--bg08WKrSYDhXBjb5--
