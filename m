Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761192Ab2FGRSz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 13:18:55 -0400
Received: from mout.web.de ([212.227.17.11]:54263 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759814Ab2FGRSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 13:18:54 -0400
Message-ID: <4FD0E27B.6060502@web.de>
Date: Thu, 07 Jun 2012 19:18:51 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Andreas Hartmann <andihartmann@01019freenet.de>, bhelgaas@google.com,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org
Subject: Re: [PATCH] PCI: Add Ralink RT2800 broken INTx masking quirk
References: <20120606212241.6627.98371.stgit@bling.home>  <4FD047A7.6050602@01019freenet.de> <1339088741.26976.19.camel@ul30vt>
In-Reply-To: <1339088741.26976.19.camel@ul30vt>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigEFD92275E50F2B896D89A424"
X-Provags-ID: V02:K0:+ogl5d5R32k9J1Vm0ViRZzpQz4F6S9fRfIXM5ArGKyK
 HSHW6Oy1Th8nhNwZu76kwBVEhbG57ft2lzf4LCJnF2bup4wdHX
 v+fdL2qpR1y4TH0jvlc2ULcSWpDMS9ZYduv52dRRzHNM8H0295
 A8dJpiEgFjoXc+A21fh1XVYawqJcxKrKaZ2M14eYFR5sKDJL9s
 ptj+RZQqKnvUZG1N4qd3w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigEFD92275E50F2B896D89A424
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 2012-06-07 19:05, Alex Williamson wrote:
> On Thu, 2012-06-07 at 08:18 +0200, Andreas Hartmann wrote:
>> Hello Alex,
>>
>> what about a module parameter to achieve this behaviour manually by
>> the user without recompiling? I fear, there are much more candidates
>> out there needing this "feature".
>=20
> Yeah, that's probably a good idea.  For debugging and letting users hav=
e
> a workaround rather than any kind of regular use.  I'll add a nointxmas=
k
> to vfio-pci with a description indicating that if it fixes a device to
> report it for quirking.  Thanks,

Isn't this controllable on a per-device base from userspace (or is this
what you mean)? That would nicely align to qemu-kvm's pci-assign
share_intx property (and may allow to map pci-assign's user-visible
interface to a vfio backend one day).

Jan


--------------enigEFD92275E50F2B896D89A424
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk/Q4nsACgkQitSsb3rl5xRNewCgkhpnHN2gmRT09/Sf+Y2cWY4G
DXQAoIUukE33nbaGynPV/cy8J3ypNXYT
=WJb/
-----END PGP SIGNATURE-----

--------------enigEFD92275E50F2B896D89A424--
