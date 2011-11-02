Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1KBU6l (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:58:41 -0400
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:39455 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751479Ab1KBU6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:58:38 -0400
Date: Wed, 2 Nov 2011 13:58:34 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        joerg.roedel@amd.com, bhelgaas@google.com
Subject: Re: [PATCH] pci: Fix PRI and PASID consistency
Message-ID: <20111102135834.2310fd2d@jbarnes-desktop>
In-Reply-To: <20111102200647.8266.62606.stgit@bling.home>
References: <20111102200647.8266.62606.stgit@bling.home>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TsoE+uki8D_fNKUSdtNpTYs"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/TsoE+uki8D_fNKUSdtNpTYs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 02 Nov 2011 14:07:15 -0600
Alex Williamson <alex.williamson@redhat.com> wrote:

> These are extended capabilities, rename and move to proper
> group for consistency.
>=20
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---

Applied to -next, thanks Alex.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/TsoE+uki8D_fNKUSdtNpTYs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOsa76AAoJEIEoDkX4Qk9hfJsP/RXyYAMQMrBYGZVS5ibWskE9
ulaO5IMtoKAV77P4ctF1BFZt+DRBYWJtn1qJ5/QEA+Pm5Xilf2WQlijzEgKiS8wU
rWaHvve/0FMQeE6KmG76CAIEewQCR+BCasad/BE7mafPiy5l9YlJx//udgf4Nuy5
DtcjDQQIQ5D6yZYEh9exT5FA7NMjQb+loURX7ekzPPzcHIPfuHr3F7toTRNHBORi
Onj/BLZObdRKYnV1gr/8X2E3iTIP+vivJtnWSrHGtCRoxBmv4u5uErjdUPle5BIf
YXOh//hIj7IJYMHXltf3gdK7Roy/A/8rkzgPDXA6kJFqA3auu3//7UXbuoQQfxru
hl1gI1mqWgZrYvkbiesJs58HRPIndHWHaIls2+i67aYDGnysPTCYZqzdeqAMzdoj
JMLyu/XNCo2UfaTcEheTTHkoOz4jcP5l857170o7hr6VLttIGZUQx7W5c5HveIjf
32e3BYGvRAtU2sc154653VeO9/J7v/e41m2A4OUoFbpbhKXUPSnmSWlUwGuNFWeY
wcdCPWzG/tudLj9ndUvXkjRwZwnlYi3o56MSOaMH5eu1rgyvXeMeHZghp+Hh/Mvk
ngTmXfzMOjDISONFzt6aO6HfjStwnZuHwLqCX29BhBHSleeFAyY6bbe2cJ4MEN5B
sap83e4M7MtLAlS7rNgR
=6ZY3
-----END PGP SIGNATURE-----

--Sig_/TsoE+uki8D_fNKUSdtNpTYs--
