Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758138Ab1KKRkN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 12:40:13 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:33215 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753986Ab1KKRkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 12:40:11 -0500
Date: Fri, 11 Nov 2011 09:40:25 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        joerg.roedel@amd.com, bhelgaas@google.com
Subject: Re: [PATCH 2/2] PCI: More PRI/PASID cleanup
Message-ID: <20111111094025.34ad5bc3@jbarnes-desktop>
In-Reply-To: <20111111170702.32668.50363.stgit@bling.home>
References: <20111111170319.32668.48479.stgit@bling.home>
	<20111111170702.32668.50363.stgit@bling.home>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/X3eNqR3X1b1m.Z2W85HOi+t"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/X3eNqR3X1b1m.Z2W85HOi+t
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Nov 2011 10:07:36 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> More consistency cleanups.  Drop the _OFF, separate and indent
> CTRL/CAP/STATUS bit definitions.  This helped find the previous
> mis-use of bit 0 in the PASID capability register.
>=20
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---

Thanks Alex; Joerg I'll wait for your r-b and tested-bys on these.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/X3eNqR3X1b1m.Z2W85HOi+t
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOvV4JAAoJEIEoDkX4Qk9hw80P/1m30Q+ImyCp7xeGE7Z44Y05
tdg2yejx4EZyajoxV2aIfeUBffs548FgZJR/nmpUdtFhdFhn+ITJWuerL1Mi1OvW
IR5Mi/un8d0bzR66KXxNRVmbrNw/MjeKuZLA6UEQrgsvfYmDdbJFjM2yRUgiR5MY
GyPmHT9RVJVLLu6iHSD+VGm2npOOYRBXkaD998Pohk1eZuRu22wL/quxD2hBy/ba
Gur0Dind2LVQndiSiXBPXZRzvqvjchFNiwPlzhhdEscbaVy92PeribUT8pQzjZ2e
i0qi2wYnxMLby7lsPPcqBYU1O//1MA96PlTqyvO1Kx9ydkr5OjCE2IEk6XR4DgH3
R68wG6eiGSuaLraVJKzf9rijGN9i3338GiUeliYL5C0Dgq+zF4F7brrSBG4uPmqP
MScQoDunZyLfgaJm2E5sdANi80XOLAj37c1LKDrBnqOC2lN8Q1rKy2eJD4Hjntaf
nIQE6DZDr6gv9n7ENCLeUK/qB6Btwjf6AV1xv2RBQcTpKvJkNge+UbWEY1mPXLN7
uFESg0ju1kTFVAydFXid8WK2xaLbVQeZhhNrVRagnVZEgbGOsdAnV9LV5vj1wo5m
5hcuFnHZfq8gwXzlC87maOrGUd2rWVPv//PqDlG5Q9aA+V/wZNj6A5pen1Lb94p/
QAo/KtRWcYB0NzY25d07
=IlQZ
-----END PGP SIGNATURE-----

--Sig_/X3eNqR3X1b1m.Z2W85HOi+t--
