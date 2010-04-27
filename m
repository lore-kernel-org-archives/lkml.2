Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab0D0RTG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 13:19:06 -0400
Received: from liberdade.minaslivre.org ([72.232.254.139]:52385 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab0D0RTE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 13:19:04 -0400
Date: Tue, 27 Apr 2010 14:18:55 -0300
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-acpi@vger.kernel.org, rui.zhang@intel.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: fix fan module removal when ACPI_PROCFS is
 disabled
Message-ID: <20100427171854.GE1493@holoscopio.com>
References: <1272385158-4080-1-git-send-email-cascardo@holoscopio.com>
 <alpine.LFD.2.00.1004271309190.4006@localhost.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EY/WZ/HvNxOox07X"
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1004271309190.4006@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EY/WZ/HvNxOox07X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 27, 2010 at 01:12:49PM -0400, Len Brown wrote:
> > When ACPI_PROCFS is disabled, /proc/acpi/fan/ directory is not created.
> > So, it should not be removed during the module removal either.
>=20
> Yes, this patch would make the #ifdefs consistent.
> But it looks like remove_proc_entry() just silently does nothing
> if the directory is not there, yes?
>=20

No, I get a WARNING right now. That's why I hit the problem, I've just
randomly removed fan.

> What I'd really like to see is a patch removing fan.c's proc code=20
> completely.  It was scheduld for removal in July 2008.
>=20

Well, no config for "old fan /proc files"? Simply drop it? If that's OK,
I'll gladly submit another patch.

> thanks,
> Len Brown, Intel Open Source Technology Center

--EY/WZ/HvNxOox07X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJL1xx9AAoJEEWxSg7udFZIZewQAJPQX6ABcApgwy5Qoe6usmcX
+46F5aRnziy/t4xxyKkRSJ0ZenGb5ma4fjIqhGWZ4D4G1Aoeg14Ia2E61gyL2Qss
oHwmv8qkOVtsmg8NFX8mfIVJEkGn9iW+BoJ/CHjbyYfY4U6Z1U52B/hmSlUiRzKC
a5gF3Oz+DcFJqATk1/uRuQ1fSXWgKTPpt6liKFAQnHIplJ85TW3is4VDcIiBkJiD
gsxN9C/NaKBioMK+a5pq4/EYwl0q5oIi1VrjqZaJuly1VWFV+tTlFeW8w7QH6qN1
oqYppHj3QX+hvv2Zj6+Q/ai2i7mFtiutIqOBhrujqhZhVzyPZ+zN7ow9K7M0Xnpu
kBMCEIdtEEjzL0V/7r3/Y5OjvYV9wkh8j2ZqW7/KbRcvmj4ePFiX/G78vvFVhxqe
FOGssAAshUg4FiyN82adhSQU/rZgjJ7/dJNs/e//GUxzJBBUdwong5mN656h34GK
TQraDLKrUkR+PDSz6RjbJb1aNu958jEVOVKJEwAdKh7edRI5TALb/lSgvTFlrNdz
LSKzjeKuxB032zCRTxaI4hCSrCA6RhACsxz2AOujYbE/fua/lQaKJOcW/7fXQ0oP
UuaMApPb8ZrwDo/LSoL+oFhfLy1m5KVmLb/KH55y+BifTB5foRUgagp8ErSpqIug
bFZBmKuhaq5Q3axj0Eby
=HXjH
-----END PGP SIGNATURE-----

--EY/WZ/HvNxOox07X--
