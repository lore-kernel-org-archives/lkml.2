Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801Ab0DOK2S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 06:28:18 -0400
Received: from mail-bw0-f225.google.com ([209.85.218.225]:42346 "EHLO
	mail-bw0-f225.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752387Ab0DOK2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 06:28:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=vnBF2qVMvs39XS5gwt1Xm0/YgcXgIrqJEOMqB6Sa20mZsDfYyD4qImX+lhMxAmjKTU
         CexS33Uf2OgCcAswMfExYLKC0M5sTOOuYL1DfY4m4ww/4HnCdVM9YM6us3hRruc1bKCN
         lRVR9AAEeW86qcbGUPXOEzXC/Pe4jSi5QeJGU=
Date: Thu, 15 Apr 2010 13:28:59 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Alexey Starikovskiy <astarikovskiy@suse.de>
Cc: Tero Roponen <tero.roponen@gmail.com>,
       Luca Tettamanti <kronos.it@gmail.com>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, len.brown@intel.com
Subject: Re: [acpi:battery?] kernel oops on boot
Message-ID: <20100415102859.GA3299@swordfish>
References: <20100414095750.GA3304@swordfish.minsk.epam.com>
 <20100414131324.GA6598@nb-core2.darkstar.lan>
 <alpine.LFD.2.00.1004141641010.3640@terrop>
 <4BC5CA13.3070801@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="+QahgC5+KEYLbs62"
Content-Disposition: inline
In-Reply-To: <4BC5CA13.3070801@suse.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--+QahgC5+KEYLbs62
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hello,

On (04/14/10 17:58), Alexey Starikovskiy wrote:
> Please see the patch in https://bugzilla.kernel.org/show_bug.cgi?id=3D157=
49
>=20

Seems to work. Thanks.


	Sergey

--+QahgC5+KEYLbs62
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkvG6msACgkQfKHnntdSXjTQYwP/b36CW8IQVG+DSJBt7iVVJex8
S+PoOnwhI7o+VtRgDy4OoCwjjWpemV04qbLXIT6/KDeF3/48aSHTYUOq4k4K28Gs
cvTQblMkm9L49QR2M6W4ZU4acKwKWfGYXMyc6yYjCmBTuHhIOdr7q9aXVUDcFuBZ
0lvxPEG4+fUpKv3XgeM=
=Vi76
-----END PGP SIGNATURE-----

--+QahgC5+KEYLbs62--
