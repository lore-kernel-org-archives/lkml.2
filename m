Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753201Ab1JMGbZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 02:31:25 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:36657 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918Ab1JMGbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 02:31:24 -0400
Date: Thu, 13 Oct 2011 17:31:17 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the moduleh tree with the  tree
Message-Id: <20111013173117.77aea58ac2a9b5a2ffc4fa48@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Oct_2011_17_31_17_+1100_eb8UblO6TwPkEN+D"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Oct_2011_17_31_17_+1100_eb8UblO6TwPkEN+D
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

Today's linux-next merge of the moduleh tree got a conflict in
arch/arm/plat-s5p/dev-tv.c between commits from the s5p tree and fixup
patch "arm-Add-export.h-to-recently-added-files-for-EXPORT_.patch" from
the moduleh tree.

The file above has been removed, so I dropped that hunk from the patch.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__13_Oct_2011_17_31_17_+1100_eb8UblO6TwPkEN+D
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOloW1AAoJEECxmPOUX5FEhtsQAIHiz8wCcYkClpP+Vj6cCg1w
rsmJNKIqci7zDs7EUNr+c0YhqKcDhYlWZ2k6MfEcjN7ILx5blQcMpLHkUPj3rJQ5
Jd5AP9Qnsf234/30GTRotc5cnIcBQ0Dk4jpSpXwl31PAG2StneHnOYhz5HICC0zk
zH/H61nZhbA4u0aQjnAFhu7Wrv8/Hnz32TRPupMS+CqX3gAckFin/uK0LKM9disc
feAzotliJfY6wlN1K3xo7+0xhqoZJM0gNN6bBy1hQB9BuHzyIxrw7aaojugePG0S
GqOdWz8UlAvkVnt7lCItugcQgMWtYQUsNZBHsUb3OHbQTKgKmTeNyUZTCwS+RKqj
H0YpyGMWpKGGgvICrDoJpzh3AOiBdaMVHFWvDN9l1zQr+mQ7AIH6brVdit/9ktgx
ZGTnU6CzGCc19h7kR30wwRe2z0QekYXdNuITLhQbB458uenIBtYI7SImOIcR6xvj
Py5P33/mD8Z+ps1aYb7TbUhpQqgk7+pSMN06mrepCktPNA7KzfIN8p8BBVIsNE9+
UdGJsGrK+KIdjaGsMxNyZta2MqlqDJXs1hqZR8o3nvs0CAqOOpa9o3GR6ly0/fgP
QA83HySBitrINf9GAFOiSwf8HG6npINB30nCRe0RFVR1N/pMMvRQESMVJRbYwXOv
KJubG5z0zI5wAvdrZUfh
=NAq2
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Oct_2011_17_31_17_+1100_eb8UblO6TwPkEN+D--
