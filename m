Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759613Ab0HLDRv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 23:17:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54693 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759562Ab0HLDRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 23:17:48 -0400
Date: Thu, 12 Aug 2010 13:17:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Wang Lei <wang840925@gmail.com>, Bryan Schumaker <bjschuma@netapp.com>
Subject: linux-next: build failure after merge of the cifs tree
Message-Id: <20100812131741.f3a800d7.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__12_Aug_2010_13_17_41_+1000_M6GjAkqiw7jO5yX."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__12_Aug_2010_13_17_41_+1000_M6GjAkqiw7jO5yX.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the cifs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

net/dns_resolver/dns_key.c: In function 'dns_resolver_instantiate':
net/dns_resolver/dns_key.c:70: error: dereferencing pointer to incomplete t=
ype
net/dns_resolver/dns_key.c:70: error: dereferencing pointer to incomplete t=
ype
net/dns_resolver/dns_key.c:99: error: dereferencing pointer to incomplete t=
ype
net/dns_resolver/dns_key.c:128: error: dereferencing pointer to incomplete =
type
net/dns_resolver/dns_key.c:136: error: dereferencing pointer to incomplete =
type
net/dns_resolver/dns_key.c:143: error: dereferencing pointer to incomplete =
type
net/dns_resolver/dns_key.c:144: error: dereferencing pointer to incomplete =
type
net/dns_resolver/dns_key.c:149: error: implicit declaration of function 'ke=
y_payload_reserve'
net/dns_resolver/dns_key.c:162: error: dereferencing pointer to incomplete =
type
net/dns_resolver/dns_key.c: In function 'dns_resolver_match':
net/dns_resolver/dns_key.c:178: error: dereferencing pointer to incomplete =
type
net/dns_resolver/dns_key.c: In function 'dns_resolver_describe':
net/dns_resolver/dns_key.c:211: error: dereferencing pointer to incomplete =
type
net/dns_resolver/dns_key.c:213: error: dereferencing pointer to incomplete =
type
net/dns_resolver/dns_key.c:217: error: dereferencing pointer to incomplete =
type
net/dns_resolver/dns_key.c: At top level:
net/dns_resolver/dns_key.c:220: error: variable 'key_type_dns_resolver' has=
 initializer but incomplete type
net/dns_resolver/dns_key.c:221: error: unknown field 'name' specified in in=
itializer
net/dns_resolver/dns_key.c:221: warning: excess elements in struct initiali=
zer
net/dns_resolver/dns_key.c:221: warning: (near initialization for 'key_type=
_dns_resolver')
net/dns_resolver/dns_key.c:222: error: unknown field 'instantiate' specifie=
d in initializer
net/dns_resolver/dns_key.c:222: warning: excess elements in struct initiali=
zer
net/dns_resolver/dns_key.c:222: warning: (near initialization for 'key_type=
_dns_resolver')
net/dns_resolver/dns_key.c:223: error: unknown field 'match' specified in i=
nitializer
net/dns_resolver/dns_key.c:223: warning: excess elements in struct initiali=
zer
net/dns_resolver/dns_key.c:223: warning: (near initialization for 'key_type=
_dns_resolver')
net/dns_resolver/dns_key.c:224: error: unknown field 'revoke' specified in =
initializer
net/dns_resolver/dns_key.c:224: warning: excess elements in struct initiali=
zer
net/dns_resolver/dns_key.c:224: warning: (near initialization for 'key_type=
_dns_resolver')
net/dns_resolver/dns_key.c:225: error: unknown field 'destroy' specified in=
 initializer
net/dns_resolver/dns_key.c:225: warning: excess elements in struct initiali=
zer
net/dns_resolver/dns_key.c:225: warning: (near initialization for 'key_type=
_dns_resolver')
net/dns_resolver/dns_key.c:226: error: unknown field 'describe' specified i=
n initializer
net/dns_resolver/dns_key.c:226: warning: excess elements in struct initiali=
zer
net/dns_resolver/dns_key.c:226: warning: (near initialization for 'key_type=
_dns_resolver')
net/dns_resolver/dns_key.c:227: error: unknown field 'read' specified in in=
itializer
net/dns_resolver/dns_key.c:227: warning: excess elements in struct initiali=
zer
net/dns_resolver/dns_key.c:227: warning: (near initialization for 'key_type=
_dns_resolver')
net/dns_resolver/dns_key.c: In function 'init_dns_resolver':
net/dns_resolver/dns_key.c:237: error: invalid use of undefined type 'struc=
t key_type'
net/dns_resolver/dns_key.c:249: error: implicit declaration of function 'ke=
y_alloc'
net/dns_resolver/dns_key.c:249: error: 'key_type_keyring' undeclared (first=
 use in this function)
net/dns_resolver/dns_key.c:249: error: (Each undeclared identifier is repor=
ted only once
net/dns_resolver/dns_key.c:249: error: for each function it appears in.)
net/dns_resolver/dns_key.c:250: error: 'KEY_POS_ALL' undeclared (first use =
in this function)
net/dns_resolver/dns_key.c:250: error: 'KEY_POS_SETATTR' undeclared (first =
use in this function)
net/dns_resolver/dns_key.c:251: error: 'KEY_USR_VIEW' undeclared (first use=
 in this function)
net/dns_resolver/dns_key.c:251: error: 'KEY_USR_READ' undeclared (first use=
 in this function)
net/dns_resolver/dns_key.c:252: error: 'KEY_ALLOC_NOT_IN_QUOTA' undeclared =
(first use in this function)
net/dns_resolver/dns_key.c:258: error: implicit declaration of function 'ke=
y_instantiate_and_link'
net/dns_resolver/dns_key.c:262: error: implicit declaration of function 're=
gister_key_type'
net/dns_resolver/dns_key.c:268: error: 'struct cred' has no member named 't=
hread_keyring'
net/dns_resolver/dns_key.c:269: error: 'struct cred' has no member named 'j=
it_keyring'
net/dns_resolver/dns_key.c: In function 'exit_dns_resolver':
net/dns_resolver/dns_key.c:285: error: implicit declaration of function 'un=
register_key_type'
net/dns_resolver/dns_key.c:288: error: invalid use of undefined type 'struc=
t key_type'
net/dns_resolver/dns_query.c: In function 'dns_query':
net/dns_resolver/dns_query.c:124: error: implicit declaration of function '=
request_key'
net/dns_resolver/dns_query.c:124: warning: assignment makes pointer from in=
teger without a cast
net/dns_resolver/dns_query.c:132: error: dereferencing pointer to incomplet=
e type
net/dns_resolver/dns_query.c:133: error: dereferencing pointer to incomplet=
e type
net/dns_resolver/dns_query.c:133: error: 'KEY_USR_VIEW' undeclared (first u=
se in this function)
net/dns_resolver/dns_query.c:133: error: (Each undeclared identifier is rep=
orted only once
net/dns_resolver/dns_query.c:133: error: for each function it appears in.)
net/dns_resolver/dns_query.c:140: error: dereferencing pointer to incomplet=
e type
net/dns_resolver/dns_query.c:144: error: dereferencing pointer to incomplet=
e type
net/dns_resolver/dns_query.c:155: error: dereferencing pointer to incomplet=
e type
net/dns_resolver/dns_query.c:159: error: dereferencing pointer to incomplet=
e type

Presumably this code has not been built on powerpc before.  Casued by
commit 1a4240f4764ac78adbf4b0ebb49b3bd8c72ffa11 ("DNS: Separate out CIFS
DNS Resolver code") (and the build was probably enabled by commit
c2e8139c9f797baa46515af6d350c51823736cbb ("NFS: Use kernel DNS resolver
[ver #2]").

I can only imagine that linux/key.h is included indirectly on x86.

I have used the version of cifs tree from next-20100811 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__12_Aug_2010_13_17_41_+1000_M6GjAkqiw7jO5yX.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMY2fVAAoJEDMEi1NhKgbshz8H/3m6+hYkiPGg8OjlzRJgupHp
FmDNLNA+E0LZlVT4JblNMaS+LrgRKdaC4MYOHt8pbkMtfN2n9Rfx1qKv82uIgvuh
XbSGPwKxhgYUDQyPaRPu9+6oHPbLwJ5Hd1ayrNDmsLnyJG0M+AD8QniPkEeQU3XM
yk9bA4x7ZoUJKSUC/QZ/fkNB+xs2drNHRlinf/PdiaJqb83KZ9fYt+J7ukwZXA1T
ofS5UUKJghn5uQGDPn+LbWmt25sskibDbdUvm3HurRSDbCossr4AC4dlh+eVCk1j
tjwavAVFnF+p3YxwumT2TlYrMP+Pf+xtMEL4vCqAKOtBcCxbIPdXtDi98dxQUYA=
=GlKf
-----END PGP SIGNATURE-----

--Signature=_Thu__12_Aug_2010_13_17_41_+1000_M6GjAkqiw7jO5yX.--
