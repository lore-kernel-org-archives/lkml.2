Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1BECfB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 21:35:01 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:34286 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116Ab1BECfA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 21:35:00 -0500
Date: Sat, 5 Feb 2011 13:34:50 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: mmotm 2011-02-04-15-15 uploaded
Message-Id: <20110205133450.0204834f.sfr@canb.auug.org.au>
In-Reply-To: <201102042349.p14NnQEm025834@imap1.linux-foundation.org>
References: <201102042349.p14NnQEm025834@imap1.linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__5_Feb_2011_13_34_50_+1100_k0MW0ZN4ih/FAHLM"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__5_Feb_2011_13_34_50_+1100_k0MW0ZN4ih/FAHLM
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri, 04 Feb 2011 15:15:17 -0800 akpm@linux-foundation.org wrote:
>
> The mm-of-the-moment snapshot 2011-02-04-15-15 has been uploaded to
>=20
>    http://userweb.kernel.org/~akpm/mmotm/
>=20
> and will soon be available at
>=20
>    git://zen-kernel.org/kernel/mmotm.git

Just an FYI (origin is the above git repo):

$ git remote update origin
Fetching origin
fatal: read error: Connection reset by peer
error: Could not fetch origin

Also, I create a similar git tree myself and two of the patches would not
import using "git am" due to missing "From:" lines:

drivers-gpio-pca953xc-add-a-mutex-to-fix-race-condition.patch
memcg-remove-direct-page_cgroup-to-page-pointer-fix.patch

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__5_Feb_2011_13_34_50_+1100_k0MW0ZN4ih/FAHLM
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNTLdKAAoJEDMEi1NhKgbsoi8H/354IpMw8OPU8BDCQtOPgC7s
/P647C82DXRsBI+MOsaVr3NXZVsf0fsVePClDOXTvTVhExfL36m0Iez4FIEirlIT
ArenVkhNt7Dz/c0UEQVMAElQUUq7gUX96f7ioZJCYNDufXQumy6D2npqZSDLVcUE
+4JnSFuvvEWTOyVklAeZK1hPbEcRYiyiSNHvz19SjzEzYFzordgh2Wiy64Ll+xFV
l6Wpi6RHspCxg0jof1SMAbWA6qbUj0QqmwJzeSxDWX0hJ5BISky2NfCTmUsuAkwl
kPJv3+bxiIPdR5wTvbQnth1Jn5ScY/O9fJhbo5V5fn+2cn/aOdml8BDJTeUOV6I=
=rmNj
-----END PGP SIGNATURE-----

--Signature=_Sat__5_Feb_2011_13_34_50_+1100_k0MW0ZN4ih/FAHLM--
