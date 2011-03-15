Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757043Ab1COKWh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 06:22:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58555 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755702Ab1COKWf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 06:22:35 -0400
Date: Tue, 15 Mar 2011 21:22:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: Hans de Goede <hdegoede@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the final tree
 (jdelvare-hwmon  tree related)
Message-Id: <20110315212226.7e940b51.sfr@canb.auug.org.au>
In-Reply-To: <20110315103228.30233acc@endymion.delvare>
References: <20110315192428.ce74a177.sfr@canb.auug.org.au>
	<4D7F2609.3080508@redhat.com>
	<20110315103228.30233acc@endymion.delvare>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__15_Mar_2011_21_22_26_+1100_LVN.W+dJdC3IIpol"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__15_Mar_2011_21_22_26_+1100_LVN.W+dJdC3IIpol
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

On Tue, 15 Mar 2011 10:32:28 +0100 Jean Delvare <khali@linux-fr.org> wrote:
>
> Stephen, sorry for the inconvenience, both Hans and myself build-tested
> the new code on an architecture where <linux/delay.h> gets included
> implicitly, so we didn't notice it was missing.

It happens.  It seems that delay.h is almost always the one that is
forgotten.  X86 builds include it implicitly but powerpc doesn't.

I wonder if we could concoct a nice checkpatch test for it.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__15_Mar_2011_21_22_26_+1100_LVN.W+dJdC3IIpol
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNfz3iAAoJEDMEi1NhKgbs3BEH/2jJzho5CMzoia9o085x7rpZ
DmdnkEibscMe+ztzSYAh/mx+/2eNTHPfqNN8QOk9G5hPY7Q1CRe/TC/S0AeVbuwc
6+vCGuR/4fAiBMFCXOyP5El2zWBsk7ZgeiDpOaOo+dfjWjQqd559xSma4XioOhLZ
xsHAWM+xo0QnnV0yLcFbn8RYyKM87d7JQNaG41M6QBqg5hjIaiClpMwd5rU82pzW
nvV5qrApI1TqUYtxyMzvVWDCnK7Xt1kvkfuReQiIok3OnyMxjEiKxWkaqJUceWTD
Gt0z9qvRh6DjEIr5XXqjH27dECT4+JoIDRZC1ab0TITZCFp0dTQ0lUUmTXyHXBg=
=mzoh
-----END PGP SIGNATURE-----

--Signature=_Tue__15_Mar_2011_21_22_26_+1100_LVN.W+dJdC3IIpol--
