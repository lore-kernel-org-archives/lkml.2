Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935762Ab0GPHLd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 03:11:33 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36339 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935725Ab0GPHLc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 03:11:32 -0400
Date: Fri, 16 Jul 2010 17:11:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20100716171124.064cf319.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__16_Jul_2010_17_11_24_+1000_tvt=U5h_coHdSTys"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Jul_2010_17_11_24_+1000_tvt=U5h_coHdSTys
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Russell,

After merging the final tree, today's linux-next build (most, if not all
arm configs) failed (not unexpectedly) due to the lmb -> memblock rename
(commit 95f72d1ed41a66f1c1c29c24d479de81a0bea36f "lmb: rename to
memblock").

See http://kisskb.ellerman.id.au/kisskb/branch/9/
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__16_Jul_2010_17_11_24_+1000_tvt=U5h_coHdSTys
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMQAYcAAoJEDMEi1NhKgbs5BsIAIRq/cPSMjaBSZzKJQHqkeCq
nklIUU9+7iwiL3lXxDgGEh1AYEoMytawLZqk4UuSv8caIlpUInJO3cvzcrhzG4/E
bYYwdZyl2eG2C4btEzktaCwBP7d5YY6aClvnvaoZzyZvnEvVmmzfCEkPpGSOonSe
8txCrelUeglpvDQVhU1USGpklAB5KTA/W1/TI/QinnEU1cY3WhKm4SIj5o194JTZ
5VkVw01ZdVO5LoWOwJ2kiucXMlQl9VDkW+p21844ztw27sqCYXJbw9+Xbao5jtWB
hFDUAYxaSXbZUHUA98tnJecCA3IZ5G+4IYUxA+uLw9JoOnfjC9sp+PhE6k7W7tQ=
=+uX3
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Jul_2010_17_11_24_+1000_tvt=U5h_coHdSTys--
