Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932263Ab1FJSj2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 14:39:28 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:40957 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932144Ab1FJSj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 14:39:26 -0400
Date: Fri, 10 Jun 2011 21:39:20 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Tatyana Brokhman <tlinder@codeaurora.org>, greg@kroah.com,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org, balbi@ti.com,
        ablay@codeaurora.org, open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] usb:dummy_hcd: Force FS device connection according
 to module parameter
Message-ID: <20110610183918.GX31396@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1307703207-14087-1-git-send-email-tlinder@codeaurora.org>
 <Pine.LNX.4.44L0.1106101112410.1921-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="TOkWJigZa0YodlBE"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1106101112410.1921-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--TOkWJigZa0YodlBE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 10, 2011 at 11:12:57AM -0400, Alan Stern wrote:
> On Fri, 10 Jun 2011, Tatyana Brokhman wrote:
>=20
> > This patch adds a new module parameter to dummy_hcd: is_high_speed
> > When set to false the connected device will be forced to operate in FS
> > mode. The default of this parameter is true.
> >=20
> > Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>
>=20
> Acked-by: Alan Stern <stern@rowland.harvard.edu>

applied, thanks

--=20
balbi

--TOkWJigZa0YodlBE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8mTWAAoJEAv8Txj19kN1LPwH/2tuh9gYzKVqcjeBu3kwu37v
vcGs3kGAoKYyKRN6EMmYedzBe+ReNsXy7NEvNWuNuz6RHnAxzIvFXNUNth7koG95
WkC+rDu3MZwWYXTceNbu/CfXELxvfSe6oTAXTJfPtMJLBsr8/Z6/kLS0dzSe2LT5
dsSpvKs0DNuXUqMPXzPtEd9KnO5c+3kSu3+Ag/gQS6YLPRPmMvFTbaksjs+gM3hu
f8SduTafx1mNzeqbtF+0WUZhQcQFDzM3lbGQa8xpDIcWiQxgXdOdhJffSFE1P3CA
q9vNt0obgQFsarkR5nH8AnTQTL3W/9SPfJCsjFjHgiQvABHifyKEvskB4ytccNk=
=bZtw
-----END PGP SIGNATURE-----

--TOkWJigZa0YodlBE--
