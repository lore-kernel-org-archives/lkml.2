Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473Ab1HPG54 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 02:57:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59679 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750869Ab1HPG5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 02:57:54 -0400
Date: Tue, 16 Aug 2011 16:57:44 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, jeffrey.t.kirsher@intel.com
Subject: Re: linux-next: build failure after merge of the final tree (net
 tree related)
Message-Id: <20110816165744.5c069b0c9f2e329e48ecd7d0@canb.auug.org.au>
In-Reply-To: <20110815.231116.1728582609642497613.davem@davemloft.net>
References: <20110815152048.3b8f8484faf1891ef2fce266@canb.auug.org.au>
	<20110814.225610.2264854100578866902.davem@davemloft.net>
	<20110816152815.911f15937efa2ebf58a2795d@canb.auug.org.au>
	<20110815.231116.1728582609642497613.davem@davemloft.net>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__16_Aug_2011_16_57_44_+1000_dfhDQ7Gjl9jnTspS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__16_Aug_2011_16_57_44_+1000_dfhDQ7Gjl9jnTspS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 15 Aug 2011 23:11:16 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> Please test this patch:
>=20
> --------------------
> net: Fix sungem_phy sharing.

This fixes my allyesconfig build (and doesn't break any of the others :-)).

Tested-by: Stephen Rothwell <sfr@canb.auug.org.au>

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__16_Aug_2011_16_57_44_+1000_dfhDQ7Gjl9jnTspS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOShToAAoJEDMEi1NhKgbsq+YIAJUK5cC7nhyfBANfWvfrb9Oj
roJII11JIo3Rs/AIfqLFDgKciMFUgIOpfH9054Db2zOZKL61oB35ZMdhHIlle/6a
/FcyTs8jkZ59Jp08vEAHLOQqpb2/G9vjAupumc2q4+e17Jo5xzliNSgxCzXtFkVZ
AxUM3NAPQ1f6Y2zv+c6CgwN5KfJzKGWDuuIKNnlpg2DfZUgIpjzkj5QggAjXDeJv
QyZ81ovzXRCTmfNPvMq55YgGXfZqc13LuScISGh5vda73/ZQcrNOKLJ71V1P0Hze
gQXfAqVXARcvl18l9YDlmBA1+1T2xg2YXxYyLJDUPsYb0AQ2FXhXZ8VfKIICDLk=
=TVTP
-----END PGP SIGNATURE-----

--Signature=_Tue__16_Aug_2011_16_57_44_+1000_dfhDQ7Gjl9jnTspS--
