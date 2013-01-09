Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab3AIVyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:54:41 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:58625 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932935Ab3AIVyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 16:54:35 -0500
Date: Wed, 9 Jan 2013 22:54:28 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-tegra@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Murray <andrew.murray@arm.com>,
        Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 05/14] lib: Add I/O map cache implementation
Message-ID: <20130109215428.GA13648@avionic-0098.adnet.avionic-design.de>
References: <1357764194-12677-1-git-send-email-thierry.reding@avionic-design.de>
 <1357764194-12677-6-git-send-email-thierry.reding@avionic-design.de>
 <201301092119.57067.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <201301092119.57067.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:w7zvEoydkfZ+ek1GILY+pl5vY1cri0Pmky6kUyi6VH7
 rWuM75IoSRRP+xMrKF9GuAH5+S9YDkQux5tM3Kdgo1LrQOUg8j
 OX0W2pCMkgElFCVo71M2kf6UjAJAY6tlJGWn9haOciTbOri5w8
 FFAWQH5fk/dYGTi3xd6wcRm6vXYQkkJrzDZC0rlP5JEabVfmyl
 vBHncvqggzPoeg+t1YLY3f8mxR5dopAQvV1nxFrQy5vwkw9yJ3
 PhRylFjUJd71Y11coBGJck6LoR5fz8d4hIqKj/iMCAi9ULUmbk
 9RMVxp135LxFZuuWaTzZS61XTvo+AURT0M7AoJCCepzddRTKSI
 hAtj2Z00Z+sS+8iIDzls5PbscGoO69ssdaPKGuOCfO8y2uweBu
 B3tIYL0ql7aFEVYi9A8UhRGGJT0CZQXZrMiLJKdIimxLzKk1So
 Qb37N
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 09, 2013 at 09:19:56PM +0000, Arnd Bergmann wrote:
> On Wednesday 09 January 2013, Thierry Reding wrote:
> > The I/O map cache is used to map large regions of physical memory in
> > smaller chunks to avoid running out of vmalloc()/ioremap() space.
> >=20
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
>=20
> Can you explain why this is necessary and which problem it solves?
> The implementation looks reasonable, but it's not clear to me if
> we really need this new interface.
>=20
> In what cases does it actually save ioremap space?

I briefly described this in the cover letter of this series and didn't
realize I hadn't put more information in this patch's commit message.

What happens on Tegra is that we need to map 256 MiB of physical memory
to access all the PCIe extended configuration space. However, ioremap()
on such a large region fails if not enough vmalloc() space is available.

This was observed when somebody tested this on CardHu which has a 1 GiB
of RAM and therefore remapping the full 256 MiB fails.

Thierry

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQ7ecUAAoJEN0jrNd/PrOhIvQQALeDgfHITFn5nEXC12ikivTh
Ql9DWEKt8sqdDq8AQ6sDm6lnadmQyYB3OwvP0/I76s3GSJWzBRacjyTVRzQ4sBDb
3cOKPl4BHcXzifQKQqYB04XljdPSGmDsoUqQGVCprFb7uYgWv0xwaJrk6g1iKxGs
wWDUHv7aND2yqombVTzzEZFC2mHahmTVrxftuSUeP3+lvL8TIeBZS+vf0ztr0A4M
vTMPqcp6RO9omSC1VoLnh7uNNOBEVKhst2z2HFbh8INqPjAi4HAnHisb1lhCu1bN
1nP/hjV9lNglzViPvX5sf7CuAAzTlhHBvZU5yF3U7eNVtokNPRgs7m/RZFqzHTEy
MuIGuhDrRpbYon8CpoDsgu/+TVNUmBvhrN5Eph8a/1bHI/65rQ1QY9n4/Ke8Gk+I
+R//AolhiCpw9FJnKTG94flrH9EKLRWQU11FK/mjw42l32hdvsMm15LSYa5OAm1O
EwK7n0X3hUscAti/BHEmygXd5c65EkMN0/x8v3dAMCn0YrJm5CfaSP2uq8VTtCvp
YuFOgvJLn5OVsYcVTFAro1e+6sNTNwaVSewGkBrJYUReLJujgSgYsKrfL/wiGm5d
UCWluDJX9iE2HvRbB4NyLhg7XTtK5RBYsS8dviA/4I8sV1wq3cm0WYe63tsmjb70
DFoD7KlRp+wWVH5K4IWR
=EcR+
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
