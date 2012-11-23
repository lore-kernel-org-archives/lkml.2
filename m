Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab2KWLag (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 06:30:36 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:49837 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896Ab2KWLae (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 06:30:34 -0500
Message-ID: <50AF5E53.9060108@ti.com>
Date: Fri, 23 Nov 2012 13:30:27 +0200
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: [GIT PULL] OMAPDSS fixes for 3.7-rc
X-Enigmail-Version: 1.4.6
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature";
	boundary="------------enigA448A0F3739DAEE5C8E3BB6E"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--------------enigA448A0F3739DAEE5C8E3BB6E
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi Linus,

Here are a few OMAPDSS fixes for the next -rc. I'm sending these directly=

to you, and quite late, as the fbdev tree maintainer (Florian) has been
busy with his work and hasn't had time to manage the fb patches.

 Tomi

The following changes since commit ddffeb8c4d0331609ef2581d84de4d763607bd=
37:

  Linux 3.7-rc1 (2012-10-14 14:41:04 -0700)

are available in the git repository at:

  git://gitorious.org/linux-omap-dss2/linux.git tags/omapdss-for-3.7-rc

for you to fetch changes up to 8ad9375f8b7c709b89f7de4de413bb2644ba3c24:

  OMAPDSS: do not fail if dpll4_m4_ck is missing (2012-11-22 17:23:12 +02=
00)

----------------------------------------------------------------
omapdss fixes for 3.7-rc

----------------------------------------------------------------
Aaro Koskinen (1):
      OMAPDSS: do not fail if dpll4_m4_ck is missing

Laurent Pinchart (1):
      omapdss: dss: Fix clocks on OMAP363x

Tomi Valkeinen (1):
      OMAPDSS: DSI: fix dsi_get_dsidev_from_id()

Tushar Behera (1):
      OMAPFB: Fix possible null pointer dereferencing

Wei Yongjun (1):
      OMAPDSS: HDMI: fix missing unlock on error in hdmi_dump_regs()

 drivers/video/omap2/dss/dsi.c             |   13 +++++++++++--
 drivers/video/omap2/dss/dss.c             |   18 +++++++++++-------
 drivers/video/omap2/dss/hdmi.c            |    4 +++-
 drivers/video/omap2/omapfb/omapfb-ioctl.c |    2 +-
 4 files changed, 26 insertions(+), 11 deletions(-)


--------------enigA448A0F3739DAEE5C8E3BB6E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with undefined - http://www.enigmail.net/

iQIcBAEBAgAGBQJQr15TAAoJEPo9qoy8lh71Hd8QAIpyBjUhkApqd4Iq7oqsLrnd
w3+upaV03DVZLLMIkd8nkkinRaOZ+wMkHcV692nkZr+8lVu0v7CjyvTg41SU7M/B
fJuxyh6FB/2OdbCF1piEmU/j2SOCB2F+1rtyiC6VeGG5QhCRMxxAjhgV040jcolP
D+0SOiwcjB7Lm/6/9tEMnNqkJFGc79pNHu2UrXxfh3Tm4sTROuyUBv11AtO2AsVH
XM2py5B8OK8YIdgAAGDw9w27Flf/e20wLKDKiJ5kuJwKZ+SDecJP3QzvsbWWbmFb
P1Vzy9EVSntCqtippe3Mf2lgggeiMDIyH5U19E18XKUIsyFdvk7dWsRI3Xj/Y9ih
4pyP7Cwr754AvQCnScfI7soZ0jn0lCRqLUL5+lEpSCFmy/Hel/fZZmYHdP71OHVy
t+Z1TBi/8uYRkJ866vapEF5eWEzmy4mqfLPV3l/ucXyS/SMk5qdpckD4TJaZQPTK
84SRdd7LLSiD1jx00fXgyxOyMDMKSRcS9iLNKHlQ6dVG6H2wHiuYKlGM/whkjivB
5gRulzEokfUvGA2aSVuL+G/tZLVS7G+UztHyhJDSoPLOfZ3JF+zZguh8qOxOHbPw
ugM/ipw4rgNhcLVeIa8+ekYsfYDc/s/3XoWsn4VJvyXuEuNEK78vYW8rXFU/LM2K
sXKA1P7EN3COuUC9nSnA
=vHfN
-----END PGP SIGNATURE-----

--------------enigA448A0F3739DAEE5C8E3BB6E--
