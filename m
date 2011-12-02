Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab1LBJZJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 04:25:09 -0500
Received: from drsnuggles.stderr.nl ([94.142.244.14]:50050 "EHLO
	drsnuggles.stderr.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166Ab1LBJZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 04:25:04 -0500
Date: Fri, 2 Dec 2011 10:24:59 +0100
From: Matthijs Kooijman <matthijs@stdin.nl>
To: linux-kernel@vger.kernel.org
Subject: Kernel tarballs missing from the kernel.org archive?
Message-ID: <20111202092459.GX15486@login.drsnuggles.stderr.nl>
Mail-Followup-To: Matthijs Kooijman <matthijs@stdin.nl>,
	linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pzPidysGA/LEAlhn"
Content-Disposition: inline
X-PGP-Fingerprint: 7F6A 9F44 2820 18E2 18DE  24AA CF49 D0E6 8A2F AFBC
X-PGP-Key: http://www.stderr.nl/static/files/gpg_pubkey.asc
User-Agent: Mutt/1.5.18 (2008-05-17)
X-Spam-Score: -2.6 (--)
X-Spam-Report: Spamchecked on "mail.drsnuggles.stderr.nl"
	pts  rule name              description
	---- ---------------------- -------------------------------------------
	-2.6 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pzPidysGA/LEAlhn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

(Please CC me, I'm not subscribed)

Hi folks,

since kernel.org is back online, I'm missing a number of kernel tarballs
on the mirrors. In particular, I'm interested in the 2.6.21.7.tar.gz
file, which seems to have disappeared from ftp.kernel.org [1]. The
linux-2.6.21.tar.gz still exists, but none of its subversions.

[1]: http://www.kernel.org/pub/linux/kernel/v2.6/linux-2.6.21.7.tar.gz

I've (indirectly) inquired about this with ftpadmin@kernel.org (see
attached mail), but received no reply. It seems the broken links I
reported in the mail were fixed (by removing them altogether).


In any case, I'm wondering if the removal of these images is accidental
and they should be replaced, or if its intentional as part of the
kernel.org "rearchitecting" (for which I couldn't find any documentation
either).

I could imagine that the point releases of older versions getting
removed to clean up / save space, but it seems the 2.6.11.x versions are
still present, so that doesn't support that theory. In addition, I'd
argue it makes more sense to keep the latest point release (2.6.21.7)
instead of / in addition to the base release (2.6.21) as a compromise.

So, anyone know what's happening here?

Gr.

Matthijs

--pzPidysGA/LEAlhn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAk7YmWsACgkQz0nQ5oovr7zasgCfT2C58FNklrI8MgaocwHE9T79
7YMAoNCTmkFyiB13JOlLQ0mGozPy25hq
=fX59
-----END PGP SIGNATURE-----

--pzPidysGA/LEAlhn--
