Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753952Ab2KCWju (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 18:39:50 -0400
Received: from narfation.org ([79.140.41.39]:54687 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752019Ab2KCWjs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 18:39:48 -0400
From: Sven Eckelmann <sven@narfation.org>
To: Shan Wei <shanwei88@gmail.com>
Cc: b.a.t.m.a.n@lists.open-mesh.org, lindner_marek@yahoo.de,
        siwu@hrz.tu-chemnitz.de, ordex@autistici.org,
        David Miller <davem@davemloft.net>, NetDev <netdev@vger.kernel.org>,
        Kernel-Maillist <linux-kernel@vger.kernel.org>,
        Christoph Lameter <cl@linux.com>
Subject: Re: Re: [B.A.T.M.A.N.] [PATCH v2 9/9] net: batman-adv: use per_cpu_add helper
Date: Sat, 03 Nov 2012 23:39:44 +0100
Message-ID: <6126628.VHIlOyj2ru@sven-desktop.home.narfation.org>
User-Agent: KMail/4.8.4 (Linux/3.2.0-4-amd64; KDE/4.8.4; x86_64; ; )
In-Reply-To: <5094A485.4060409@gmail.com>
References: <5093EE7E.6040400@gmail.com> <5905519.yWN2Ke3YlE@bentobox> <5094A485.4060409@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1797397.lfZIgvKNiC"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1797397.lfZIgvKNiC
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="ISO-8859-1"

On Saturday 03 November 2012 12:58:45 Shan Wei wrote:
> Sven Eckelmann said, at 2012/11/3 1:55:
> > On Saturday 03 November 2012 00:02:06 Shan Wei wrote:
> >> From: Shan Wei <davidshan@tencent.com>
> >> 
> >> As Christoph Lameter said:
> >>> In addition, following usage of per_cpu_ptr can be replaced by
> >>> this_cpu_read.
> >>> 
> >>> cpu=get_cpu()
> >>> ....
> >>> *per_cpu_ptr(p,cpu)
> >>> ....
> >>> ....
> >>> put_cpu()
> >> 
> >> Right.
> >> 
> >> Signed-off-by: Shan Wei <davidshan@tencent.com>
> >> ---
> > 
> > Is this really supposed to be the commit message?
> 
> Maybe it's ok when Linus said this. :-)
> 
> Christoph is the maintainer of per-cpu.
> So........

Hm? This wasn't my question, but ok...

Kind regards,
	Sven
--nextPart1797397.lfZIgvKNiC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQlZ0wAAoJEF2HCgfBJntGyDUQALAPrg6zTPAyMpKdS3PNXEsb
JSwhZtUHdEpgxg9DKqjt+1+d20Ts4yWiMuN50+MFirgiFr/I99gatwXBO59JzONx
QPipCTA1LiguBkrWKbjuNvehx3VugNrV63NK0vkQ/6ZYnYtA1lTNGpYln648/FY+
3+O8uq1RN3IvakTuQvxAmT5yH0ekCOud/GZZQxbxDBkTNEcQzHgpeo4kNUPv59B6
lrLSCy5xrbqf+faiwbVlTwERIhiT/T94aPoYPQMlAtbQWjEBagy43YEm51Pk8ypC
hdeB5KSyODj2BSfFNFxOZzVIU9nhDqdK89QPKMrrLz6YFfvFDg8dfJmpr0ZR2O/J
cBsfqM4lFfkM3sWO35J5YVMLZPPE5Ow12iJHIEgADytXUomR2HlqacbuxhPSJKTv
O/y3bol4zQsbLY2svZnKnu5Z8RY8yI9rqraP47a91jcNP20asdLOF3r1BvdHnG8V
iB9ssmnihV6eT3Fx/rDQVSa+yVNHHJFula2C63dzyYABz3l+DqZZ2+kytgVyqD5B
68qofLyzh/eh9N4vWaWgbLHQZl5eezDw9/IMQ4s+9qrKuiX99osnl5Lyi/o7A7fz
qDneMxs1mr619E7e8GNlyJRqAJAzyzV9nPLM5dVpF85NOz3sKctrMq/nvJbGxoAh
UaxRMFnt63+pdRQjLe7c
=pgnc
-----END PGP SIGNATURE-----

--nextPart1797397.lfZIgvKNiC--

