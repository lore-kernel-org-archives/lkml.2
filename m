Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab2CUM3c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 08:29:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52637 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754776Ab2CUM3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 08:29:30 -0400
Date: Wed, 21 Mar 2012 23:29:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Greg KH <greg@kroah.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: build failure after merge of the tip tree
Message-Id: <20120321232912.a4a5abb71acbe8170a2dc0e5@canb.auug.org.au>
In-Reply-To: <20120321121954.5052ccf2@pyramind.ukuu.org.uk>
References: <20120308152110.12c805f59c45251d79bcb24b@canb.auug.org.au>
	<20120308180048.GC26516@kroah.com>
	<20120321090038.06c65f50bd0329df8705f2cd@canb.auug.org.au>
	<20120321121954.5052ccf2@pyramind.ukuu.org.uk>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Mar_2012_23_29_12_+1100_H.dyoKkbFyeMVrNV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Mar_2012_23_29_12_+1100_H.dyoKkbFyeMVrNV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Wed, 21 Mar 2012 12:19:54 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrot=
e:
>
> We don't even have a sep_driver.c any more. The massive rework of the SEP
> driver dealt with this.

Excellent, thanks.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__21_Mar_2012_23_29_12_+1100_H.dyoKkbFyeMVrNV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPacmYAAoJEECxmPOUX5FEHwYQAISgpAsT0XvE/S3C1dOAg/pe
lOQwe9g/MIuuW8XBW0pIjwIAVJbLT6XxUkK1zaGmYCbX6WauTM//adA64FCIMedt
aYg1CdPAa8sH736bOtek5XbknmtyASvFbwcWyY0ivhjsT5kvs8G9EToVOZd3yLN4
n6tnU8qbxPtW2wcm+HbllH3Uw8OaI4JLIezIeAaoOEfWTTQoyeJK4emN/6pwSt18
B3mZdkl6OY9gwTR2jg7xFIDMDRyY4TJS0MIDYKIJeD1NVIZg6LgmesTsffI3GOzP
tJbZUxF4FFT4PbZ8JTXO1ecqXb3/fnc8tLWt8B6edQ+ejtf9dL+yOfOZuNDw/790
EoGRjv6v3f7irFfrAbZ+3bCxOhb77nt9JN02IJPFYil968qFR+FM4PWJsCgS7/sx
lVkLS3K6vC69orxfHY2oP3rnCXUfXoWpe7VNjpbMPzHixw+4cWvrkamir8sTT4Ep
5XMoU5dM/ykfKiMeq37QhB68L/rQNE/SS5nbzCx0N0N/iVMmsFs4dbBKibor3+jY
a4AzNbkxDFJG/+6SrGfj6h053n3mFCKU+7YKfl3Wp7vAIqfWISqBlBNgNXZKSx41
KPTMuNbWyeDhqOuC3zRaGOzYQklDyeeIpFYPBuztXwEpkbsy+LgUS8hYPZGgeUr3
9PSsaqX3FbvYItcJ4ct9
=04be
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Mar_2012_23_29_12_+1100_H.dyoKkbFyeMVrNV--
