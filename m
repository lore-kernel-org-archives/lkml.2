Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754569Ab0K2C6G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 21:58:06 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57061 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754096Ab0K2C6E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 21:58:04 -0500
Date: Mon, 29 Nov 2010 13:57:58 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Safford <safford@watson.ibm.com>
Subject: Re: linux-next: build failure after merge of the final tree
 (security-testing tree related)
Message-Id: <20101129135758.342fb940.sfr@canb.auug.org.au>
In-Reply-To: <20101129132520.6884a624.sfr@canb.auug.org.au>
References: <20101129132520.6884a624.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Nov_2010_13_57_58_+1100_OqoOrM+m/TDzuaEU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Nov_2010_13_57_58_+1100_OqoOrM+m/TDzuaEU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

[Forgot to send this top James]

On Mon, 29 Nov 2010 13:25:20 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> After merging the final tree, today's linux-next build (powerpc allyescon=
fig)
> failed like this:
>=20
> security/keys/trusted_defined.c: In function 'init_sdesc':
> security/keys/trusted_defined.c:52: error: implicit declaration of functi=
on 'ERR_PTR'
> security/keys/trusted_defined.c:52: warning: return makes pointer from in=
teger without a cast
> security/keys/trusted_defined.c: In function 'TSS_sha1':
> security/keys/trusted_defined.c:65: error: implicit declaration of functi=
on 'IS_ERR'
> security/keys/trusted_defined.c:67: error: implicit declaration of functi=
on 'PTR_ERR'
> make[3]: *** [security/keys/trusted_defined.o] Error 1
> security/keys/encrypted_defined.c: In function 'aes_get_sizes':
> security/keys/encrypted_defined.c:73: error: implicit declaration of func=
tion 'IS_ERR'
> security/keys/encrypted_defined.c:74: error: implicit declaration of func=
tion 'PTR_ERR'
> security/keys/encrypted_defined.c:74: warning: format '%ld' expects type =
'long int', but argument 2 has type 'int'
> security/keys/encrypted_defined.c: In function 'init_sdesc':
> security/keys/encrypted_defined.c:270: error: implicit declaration of fun=
ction 'ERR_PTR'
> security/keys/encrypted_defined.c:270: warning: return makes pointer from=
 integer without a cast
> security/keys/encrypted_defined.c: In function 'init_blkcipher_desc':
> security/keys/encrypted_defined.c:351: warning: format '%ld' expects type=
 'long int', but argument 3 has type 'int'
> security/keys/encrypted_defined.c: In function 'encrypted_key_alloc':
> security/keys/encrypted_defined.c:536: warning: return makes pointer from=
 integer without a cast
> security/keys/encrypted_defined.c:547: warning: return makes pointer from=
 integer without a cast
> security/keys/encrypted_defined.c:552: warning: return makes pointer from=
 integer without a cast
>=20
> Caused by commits d00a1c72f7f4661212299e6cb132dfa58030bcdb ("keys: add new
> trusted key-type") and 7e70cb4978507cf31d76b90e4cfb4c28cad87f0c ("keys:
> add new key-type encrypted").  Missing include(s).  See Rule 1 in
> Documentation/SubmitChecklist.
>=20
> I have reverted those commits for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Nov_2010_13_57_58_+1100_OqoOrM+m/TDzuaEU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM8xa2AAoJEDMEi1NhKgbsrBMH/2fjCU4GmetTbb/byA7EaYKq
/TeL73XzsOLc9T1MvawTVJ4H/Nj70jw02matWCYtWJurY1io+NUdTZXy7MCH2SHU
Ydx2xvpU0ieE68vZzw3wAFOu0WmmhNkSVAcZVDyRbQ6N+49604Dya2lWHDTWHSQ3
RaNRco192xwfwuii+AKloUmuq/vnX675aZm+lImUD41ywQ4FRbk1HDc34jqPmImD
fzcGCwl/awUxmiAQyZOewmC+btlZr19wgYwbm2+IahaqfcruGoNyQX6EDh6nedI5
pQfpsaHgu8vig/uFZspP6umM9gpPdCTfIpUONsk8lqNg3pqJqZfbNmz9bJh6UrA=
=s52F
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Nov_2010_13_57_58_+1100_OqoOrM+m/TDzuaEU--
