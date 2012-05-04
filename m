Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab2EDAOu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 20:14:50 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42866 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755455Ab2EDAOs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 20:14:48 -0400
Date: Fri, 4 May 2012 10:14:39 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: linux-next: strange commits in the drivers-x86 tree
Message-Id: <20120504101439.edb8133fe986fc4cca94b969@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__4_May_2012_10_14_39_+1000_cr0+PaN876nXjq_z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_May_2012_10_14_39_+1000_cr0+PaN876nXjq_z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

I have no idea what you have done to your tree, but it now contains scsi,
nfs and arm commits (at least) that don't appear to be at all relevant to
x86 drivers ... it looks like you may have rebased part of Linus' tree
onto yours.

I will use the drivers-x86 tree from next-20120503 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__4_May_2012_10_14_39_+1000_cr0+PaN876nXjq_z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPox9vAAoJEECxmPOUX5FEbdoP/0hqFJneOvyrB5ZL5boXGZlJ
Qxz2LQuQLYzYgg8imCwTqzYLef5EFEM8N90uusilGjdgHan+jigqxZ+rWnQLHKEo
X/Db0qdg47gFaZ5UkeoZVZ16R/xlCEKEcv+TE/hH04Z7yBiaswZiFS2bbJnoFs7H
6pcYjpM+l817/LTkovAaqprI7n8P8YmvUOVP3K5Jjc7N2KwbY/IOKnySDoCLDtDW
e/6arStngL34niQy7ywGGyLm5Tz3fPdtPhDigWdmF8nk3CW4R4+eLI53KDtJryBp
lSyuhHdzGc3YKsjwLlwKWvnFo8XUz6DawA0re6PQaSiW6SfaSxQmbXYaj1e6E6bo
kRh73kP85bg7NaS/mbBJuhKle/9PGXPx1k3PN/J3EKkmScH+tAbW3C3UThHYyEHA
8FXgEY3NRlrC+7iUQHKfpw2xUOKepdS4mQHyB1u7wUjCKlsZQUFFbetg7FxtCxiY
7uLJiptaNZ1oR9EqfBWw8tjmP9rd0S6MzfQi/zCcNsNU9c6pmpXzg90BxfsbHvOS
d3QaKcbIFW0RpQB2V0jMnDz9P6L6u+5vLjvh6h4Hz7MJCOjGdd79+PGlzR9KwCVI
KXFWMs6Ru4MRu1zuco6+ssj3EuDa/TfVQdv9npgXL4A7AkIk4SvmiA67t5Hbenpg
BbIg5ZBw7ARdUDMFHq8r
=nQz/
-----END PGP SIGNATURE-----

--Signature=_Fri__4_May_2012_10_14_39_+1000_cr0+PaN876nXjq_z--
