Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758651Ab1E0CIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 22:08:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34154 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752915Ab1E0CIe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 22:08:34 -0400
Date: Fri, 27 May 2011 12:08:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
Subject: linux-next: build failure after merge of the nfs tree
Message-Id: <20110527120824.095e3b8b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__27_May_2011_12_08_24_+1000_CdPA4C5EE+tC63sR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__27_May_2011_12_08_24_+1000_CdPA4C5EE+tC63sR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

After merging the nfs tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

fs/nfs/nfs4state.c: In function 'nfs4_schedule_session_recovery':
fs/nfs/nfs4state.c:1469: error: 'clp' undeclared (first use in this functio=
n)

Caused by commit 67191d2ed1e4 ("NFSv4.1: Fix the handling of
NFS4ERR_SEQ_MISORDERED errors").  This was clearly never compiled :-(

I have used the nfs tree from next-20110526 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__27_May_2011_12_08_24_+1000_CdPA4C5EE+tC63sR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN3weYAAoJEDMEi1NhKgbsjy8H/jtLop+1TlCjOWsM99KSruu3
8zbloyhqwv4NUosUVhhJ2L9smx/UdTQa6UL7ipkRxdJt6CI5HjglbMOsvS4wtnVP
lNoioC1Ph4ilpJArooXaHS+NRpRaRY9bLcWeCm/kW+5XBXuQlr/D34It/1yBkife
CZwkf6raizigmI24OfFenuyjcYgWnMuqivOTdnnozRylhUcKMIA96ggMvYf0B3uy
71WZdVva4gJJBt61z+FoQOH9NJvy6MAPGv03GW2TTH4ecgSyUmh5W4zq/EJ1R8Ju
NKVRlKDTZbovH8n1i/+LJGmDVPo6xaOW4aohPDpU0Wn0u8w8PCe6FyYTavaFIyc=
=cmZO
-----END PGP SIGNATURE-----

--Signature=_Fri__27_May_2011_12_08_24_+1000_CdPA4C5EE+tC63sR--
