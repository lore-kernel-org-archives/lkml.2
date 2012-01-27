Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab2A0SkT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:40:19 -0500
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:60910 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752983Ab2A0SkQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:40:16 -0500
Date: Fri, 27 Jan 2012 10:40:05 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg KH <greg@kroah.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        <linux-input@vger.kernel.org>, <linux-pci@vger.kernel.org>,
        <linux-pcmcia@lists.infradead.org>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] Dynamic ID addition doesn't need get_driver()
Message-ID: <20120127104005.6dde9416@jbarnes-desktop>
In-Reply-To: <Pine.LNX.4.44L0.1201241310400.1200-100000@iolanthe.rowland.org>
References: <Pine.LNX.4.44L0.1201241310400.1200-100000@iolanthe.rowland.org>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Ah0bVaxQFqREfpvCvj2HeRG"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Ah0bVaxQFqREfpvCvj2HeRG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Jan 2012 13:34:41 -0500 (EST)
Alan Stern <stern@rowland.harvard.edu> wrote:

> As part of the removal of get_driver()/put_driver(), this patch
> (as1511) changes all the places that add dynamic IDs for drivers.
> Since these additions are done by writing to the drivers' sysfs
> attribute files, and the attributes are removed when the drivers are
> unregistered, there is no reason to take an extra reference to the
> drivers.
>=20
> The one exception is the pci-stub driver, which calls pci_add_dynid()
> as part of its registration.  But again, there's no reason to take an
> extra reference here, because the driver can't be unloaded while it is
> being registered.

Looks fine, you can add my ack too.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/Ah0bVaxQFqREfpvCvj2HeRG
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPIu+GAAoJEIEoDkX4Qk9hLD0P/jnz89Va5dr4iXEXhK5PwRvj
ia2nWFmZA99R6bD9VaUno7L1GiOGkwQ9k+od/c0g6yQkh657BlL5xhwvYaYQDuOD
bukzyrCJl8v0k12ZkbK7SeMaabyvab7hgSenAUtJdJ38qjuog82PMLSirwS7YYvA
RFjNip1ewnxVFRfZkXSnHQDdBQtx/S16eHE1CZojNujhfwI7i4tt2O9Pt+iDi17t
zS6zh+YnZYnU4UPfNcqjJcBvqNvxq8TQ3Sg+/RAZ07nlp13FTErcXRhipZ7WZa/T
rSPXmxbFKLoViRBZ0DvpYS32hGSAjGVdUAJefF1HMlXUeSgLtwIBPJfA+6XL+0pi
nE0bO+FMSnapsaZW0ne+A4IObwkMXFLouzYxK939E3n+c/w96HZmEh/FVq00jZeG
uhTyepBcXeRJwlj2TOtoPJfAPJhflNBOYBBshG0hsL3QDIWgnM1xkkdX4KJr2yf0
rZ/bA3mcH/GL4BGiEe75zBmRhpk8LhhCAyqoNq+PwFgbgV4l6+FTtZO99WGmzTBe
z6elvrGWyvJZu7ONQeVaj9F+1E2GtaJ+Lf6YKjc7YGTG9yGV5N7IIWh/K3eA+NRX
yI7/xtscLRVmRIUjyVxrLV1wNmG7NvghAxeUNbqMtpH+voeMBc6KxgTwj4dZva5P
ENCAn1Joaf47NCms+H4D
=4RkF
-----END PGP SIGNATURE-----

--Sig_/Ah0bVaxQFqREfpvCvj2HeRG--
