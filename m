Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab1JMXD3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 19:03:29 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:33107 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab1JMXD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 19:03:28 -0400
Date: Fri, 14 Oct 2011 10:03:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jan Kara <jack@suse.cz>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org
Subject: Re: New name of ext2/ext3/quota tree
Message-Id: <20111014100321.73eee653104c1857dfa0fde7@canb.auug.org.au>
In-Reply-To: <20111013181637.GC6018@quack.suse.cz>
References: <20111013181637.GC6018@quack.suse.cz>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__14_Oct_2011_10_03_21_+1100_S3eq1D6AxPUtiOo6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Oct_2011_10_03_21_+1100_S3eq1D6AxPUtiOo6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jan,

On Thu, 13 Oct 2011 20:16:37 +0200 Jan Kara <jack@suse.cz> wrote:
>
>   since I had to recreate my tree at kernel.org, I've decided it's the
> right time to switch from linux-fs-2.6 name to plain linux-fs. So could y=
ou
> please pull
>   pub/scm/linux/kernel/git/jack/linux-fs
> instead of old
>   pub/scm/linux/kernel/git/jack/linux-fs-2.6

OK, I have switched to that.

>   Thanks. Also, since changes to UDF are rather scarce, I've decided to
> drop linux-udf-2.6 tree altogether and merge occasional UDF changes throu=
gh
> my linux-fs tree so you can drop that tree.

Also done.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__14_Oct_2011_10_03_21_+1100_S3eq1D6AxPUtiOo6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOl245AAoJEECxmPOUX5FE+yUP/j0DxAzHREYI7TIdLzX0I3JI
NTG+N9Jv7ytOEQqA/jtAfTIp8Ffb5/onxQx0P7H/Dy9VVF0DJwWlK9cEp7nlsi8X
hJEptcjU8g+Ott3P1CNw4llKYsrRjvuwQUAQClshcmin6xfkqZg4jwM6aUfbaMaB
RaEGS5FNOIWAHT/eteagJ9xZtMnvi79mKGV5nDiu+Z3O3UxpxBgL3/11m1Nu2d82
eKF0tF9k7UQDHO6FsWNTr0t+r/SNkDE3FPDsyGz69TKCnlVpfz56nP3+pepHfsrp
+BcqR36c2gG1rL18twn+ukE1twE3ibDFVv+jVXCX+0kjZqKK3M3jABBJX7YX7MgU
sTFwnDISSq/cyDm6kXvoDla3rzgYVER2v3H4gklNW1CgVvonJldjyyi0G57mXDXf
VS+FncFEZHzj9x2YwBYnUmaKFZzoyW//VZvl8NQjGJtRxIrtdYBezKSYoaIOqY4M
zIYAewySyGP77uKFmZzVt6hs7wQH/hK8Vsp/o4r/kCJBcHEUWA8HvVMc4Chrfumu
YEHAUtrNrvX6mArAC9zS4hXTyXnX09pKNRw/UgKlYWu3wZsqd83edhDWnqnjO/iE
Ox9jVso4InJtYxrGM7+sOk9Oc2Qck/H03t0swYmIMK5Xw8LzlwlMGiuSYb/afHdB
CIzhFtboqsXRlACtDvsC
=v81n
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Oct_2011_10_03_21_+1100_S3eq1D6AxPUtiOo6--
