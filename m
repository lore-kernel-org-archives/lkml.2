Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab2GBDym (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 23:54:42 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33554 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751434Ab2GBDyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 23:54:41 -0400
Date: Mon, 2 Jul 2012 13:54:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Jeff Garzik <jeff@garzik.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Holger Macht <holger@homac.de>
Subject: Re: linux-next: build warnings after merge of the libata tree
Message-Id: <20120702135429.0d17c1f4fe46828bd29b3458@canb.auug.org.au>
In-Reply-To: <1341199318.31272.2.camel@minggr>
References: <20120702131914.510857dc84182e95641e7e97@canb.auug.org.au>
	<1341199318.31272.2.camel@minggr>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Jul_2012_13_54_29_+1000_DjJ.I8UFd1kFOwEh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Jul_2012_13_54_29_+1000_DjJ.I8UFd1kFOwEh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Lin,

On Mon, 02 Jul 2012 11:21:58 +0800 Lin Ming <ming.m.lin@intel.com> wrote:
>
> Could you please send me your ppc64 .config?
> I'll do cross build on my x86 machine.

Please just look at the code added in drivers/ata/libata.h.  Hint: what
happens if CONFIG_ATA_ACPI is *not* defined?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__2_Jul_2012_13_54_29_+1000_DjJ.I8UFd1kFOwEh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP8Rt1AAoJEECxmPOUX5FENjIP/Ro2u9ZYagu5p13BrWcgd9ec
eBxtk0N1QLQ14bnsHvffzTGaIgnVG/vb3n2kFnZQ1GDrqgO8O2YhqA81ZMdVWsTm
ks70XHIS0UrF6VmjrOWZ2Mp+q6nhhDyV85iGA5GtHOA9XyBKDsQ28JOT2K8etEtL
TbVXw/+H7dcjw1/6NJ6rFkm2Uisf1Gi3Z4Iz/HoPwAlzDCnTemY3eM7AL9SFac8T
Ig5PG8Li9v5iuJ40O72YlrlCS0Lt1ySMn/jKXNfS1hrXW46biG46c9YCfcQCy0Sc
CF4+O0amtK/HNBI00UzD1guVvJHlBp4ffAL+XfP03AQ85ISgtplB6p7hAwqLP2Se
fnxpFOcseQlnyfs8VvD8LdEW0KHwAQPW4fMX/y/ArJ4ThdFdErxQoK/xzJ6eHnQl
qiVJUWi4/ezoDNGB2wZuZwU8qCByfvyUf9i1m7psAXy64jtnSO34sgheLXWBygGD
1SrgaT+vNpVfsTUShv+0eVhq7gBfPbs2p9oESP3aQqKvc4z8WjCk5VxaDydaQsjF
W/I6YmZUoFReHq1mO0VAcIfI483Oa4aghtRH55cLN1dCM3at4NAaiTiaA0tDAAKs
vgEhliNPOpcShMS6tP11DxPnxNCNvWk0e3eidQmXWp3MFAN5AeLJoNHKsT4vhhLZ
vvTAY2P6p8iWi+zERfnp
=m5LD
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Jul_2012_13_54_29_+1000_DjJ.I8UFd1kFOwEh--
