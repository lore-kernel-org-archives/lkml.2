Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab2EaQlv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 12:41:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60327 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752132Ab2EaQlu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 12:41:50 -0400
Date: Thu, 31 May 2012 17:41:49 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Krystian Garbaciak <krystian.garbaciak@diasemi.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        Anthony Olech <Anthony.Olech@diasemi.com>
Subject: Re: [PATCH 1/4] regmap: Reorganise internal read/write functions.
Message-ID: <20120531164148.GK2666@opensource.wolfsonmicro.com>
References: <201205311607.q4VG7avr012901@sw-eng-lt-dc-vm2>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="pWJxWxNlJUNgDlXi"
Content-Disposition: inline
In-Reply-To: <201205311607.q4VG7avr012901@sw-eng-lt-dc-vm2>
X-Cookie: You are fairminded, just and loving.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--pWJxWxNlJUNgDlXi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 31, 2012 at 04:11:12PM +0200, Krystian Garbaciak wrote:

> +static int _regmap_raw_write(struct regmap *map, unsigned int reg,
> +			     const void *val, size_t val_len)
> +{
> +	void *_val = (void *)val;

This is scary...  why are we casting away const here?

--pWJxWxNlJUNgDlXi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPx59GAAoJEBus8iNuMP3d+NUP/0prqnMCWBJnFtuc9aq4zLDk
H6RvDSpGemTxWRw2q39KsTGq2K1ToE/1CnQmfWmRujZTd1Q2UHh4aZSXL880IVmf
Ho/1lgEb9cjeoBVlhpHfv94omV2ebnKCJKQ6RLl4Vp8OdWcfxa4oJSu5XWuK+En5
VsvPFNV5rcTNzvx1zt+AlaaQRrs8xqKe7RVeI68qKNAAF0eIdq+lNBYdP5TjxgNK
7T27mYpHb0/7hl7wch/LFQ+dLL8dI8qxa+1MjoOZ4wXhnTMrO3dFzW6kPnE7ps+J
+XyXR0pzpp1DnWDJ+V6CpsHKWCty3W09CP3WMuXHbZPgG9OfpQ8l3JaiXwxR+AWw
ax6NDt8jh6gU4avZlwZLjHXNYITyxx4mPjEvym5J1O1qi3pJw5r49kAk0S4a5Kgw
wRrVpDcQZotUJL/RqsxcaqAiXM3NhXKZ2wfSlL0JkBbHCOAqfRDG7rGrxPuHehW/
KCrOHbzwdws1IZ9MgSlbp5kN7MRS8hOVj3p8EsjOgfmwJ2lanDOvH+H5wrbFR5S9
yy/mRAbNlZY3Xjz816doXuPpUQMIAFtl5spEIxi0abYqB6wnLa+XJkZHFY8OszsJ
xVeib5lOJSBwjwOD1bl4UU3RscTEkuHZGKY940dLWfloNATC6vrlS1PCS+REefNk
Fb2AEW18OGgs3tDvTuow
=doz2
-----END PGP SIGNATURE-----

--pWJxWxNlJUNgDlXi--
