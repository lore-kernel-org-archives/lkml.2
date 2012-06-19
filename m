Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab2FSLIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:08:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33422 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751201Ab2FSLIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:08:09 -0400
Date: Tue, 19 Jun 2012 12:08:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT 1/3] regulator: tps65023: Convert to
 regulator_list_voltage_table
Message-ID: <20120619110807.GF3974@opensource.wolfsonmicro.com>
References: <1340097138.28289.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cV8yfgwCnzpki16T"
Content-Disposition: inline
In-Reply-To: <1340097138.28289.1.camel@phoenix>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cV8yfgwCnzpki16T
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 19, 2012 at 05:12:18PM +0800, Axel Lin wrote:
> In current mapping table settings, min_uV/max_uV are always
> equal to volt_table[0] and volt_table[table_len -1].
> Thus remove min_uV and max_uV from struct tps_info.

Applied, thanks.

--cV8yfgwCnzpki16T
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4F2QAAoJEBus8iNuMP3djmwP+wWZVfThdOHoXYt4w8iB6Dk8
Hwtq5c0Es62kLaNrXipfm2ISGfzX7Q3PB8cpWJ9hvHnk7zR8lN2GVxsmLa2zGI55
9j1GAY+fenCzOlptfRR/AOCGVXlQl60YaW0Hi77F1mFvI0a+Wt+iJ97ik3Hr9K9i
s302Tc5eLz1ys1IVZ/5/1UrE+VXZWGbvN8Aoe1+5QDpKHopij3dDPZvMOch6z2PF
Olbh1fjtNWRS74bCBVgOjjWFCcM0mbx7sT00DaQ9EBKSaLOmOgTAs0cYxwvHCqwZ
FHMtAr+JRqL5RdPf1N+W5XpvEIh5MdLKQweqMdUBucZGl6W+KlhnEIzKbajAML90
ccrHBcHVVA0W2+JbKv7ErPNsiUPyDTNFS6Q+5skj+gkNOr7OZhTsg5x19z6JXzs1
pOSVa6KH0vCf/RiW937EvCv8jJM2DKaPKL7DjQjHL9tqlJQMdluiKLG//fNPSq7n
FvRjfzfVqhEB5dO0WxbDBMi3xcj1XhQ8nVYV9Jp0TeBmtCPUl9Ux81w7Fvisxuob
6RO+6/kOpfUejA+9WhN1reSNBjLHjejyKl7HgGP+f2Il/c3NroUkrYr/4lXVhBz2
CizlSnDhXfrYEAEMCFu+fwbM567FYT3gS5F7bEQL5lkHw9Ac7x4cT6FvJOZZlL3W
RJ4cMp8NJ+vU7sBMlh/V
=3Txc
-----END PGP SIGNATURE-----

--cV8yfgwCnzpki16T--
