Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab2KANT6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Nov 2012 09:19:58 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:60317 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753792Ab2KANTz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Nov 2012 09:19:55 -0400
Date: Fri, 2 Nov 2012 00:19:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mukesh Rathor <mukesh.rathor@oracle.com>
Subject: Re: linux-next: manual merge of the tmem tree with the xen-two tree
Message-Id: <20121102001953.68aa28abcae897a809f417cd@canb.auug.org.au>
In-Reply-To: <20121102001732.1c02f6a72c9cd2b894d9c6c4@canb.auug.org.au>
References: <20121101144059.a8350c24499f1beffe59a64a@canb.auug.org.au>
	<20121101130310.GA11029@localhost.localdomain>
	<20121102001732.1c02f6a72c9cd2b894d9c6c4@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__2_Nov_2012_00_19_53_+1100_vNstmSjwLOvs5A9g"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__2_Nov_2012_00_19_53_+1100_vNstmSjwLOvs5A9g
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Konrad,

On Fri, 2 Nov 2012 00:17:32 +1100 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Thu, 1 Nov 2012 09:03:10 -0400 Konrad Rzeszutek Wilk <konrad.wilk@orac=
le.com> wrote:
> >
> > I am not really sure how this happen - the 'tmem' tree should not have
> > had 7282a68f5aea, and more interestingly, I cannot find it in the
> > tmem tree! Either way, let me just reset the #linux-next to v3.7-rc3
> > in tmem tree and see if this shows up.
>=20
> The version of the tmem tree I have has commit a728d5ea1c20 as its head
> and has the shortlog below.  I has not changed since Sept 24.

Just to be sure, the tmem tree is

git://git.kernel.org/pub/scm/linux/kernel/git/konrad/mm.git#linux-next

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__2_Nov_2012_00_19_53_+1100_vNstmSjwLOvs5A9g
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQknb5AAoJEECxmPOUX5FE9ykQAKNIm2QN6aHd9WRqw2isv/bF
c0gPITJ8tuppCC2mQB8eq/4H4SDF9uJGV5PsNBc833C9TZoNzifWovH1K/8RQ/L9
Bf4JZyxmDDnpmHOSm+1rvRl6JoNolFV5EdoSMuz5AIOJ2o3mai1Z1VkDR2VcIzxE
3ykPOmMy+hyR7gYjeoUqlCOC2BIxxP7ZJMG0vf1jjF+CnCpYu7IvRcG1lWdprPlg
6zhc5p3skYOsF/VNeAOLeiI5SWBBggaxsrRP7OerlCmcA/+3ZTvdp/GQtKe+gx7l
5kTbed2TlrMVSK+1mq0l15qzQnm/O3yV0LKNyPhmZxjhNCOKxtwuDZ13QTs8sncF
k37YC1+2CbX2z3dTYj4GZvQGIGXohMgdJoCZFFsho+gYdVDSLmVrFFXfW/i5iKev
sHOBqsPAtDsXCsopuyI4xmjYhzfWNWr/Vy1iZHkOuQOwDE1dCzTmnmr5BUluCJrw
iQq3jiv3xrDVn3JIslKL7fNQk6CdwE7q6IggmX7xy50lw6qcVGGNDLG4xYhRh85b
ljEE5G1bktI11rLMZaS5Gdw6FeyocmYLp9PsN8fK8lZoNO7WuI7/ifNHLbwDytC9
Zg2ml3HIGZTOkzgbQk05fjy4VMKYRgcp3gQWeGBz7ZLwzQz1SNBjAnDlPNyWcHEI
ZRSKPNWuxnYa6q/lwGit
=Xa7G
-----END PGP SIGNATURE-----

--Signature=_Fri__2_Nov_2012_00_19_53_+1100_vNstmSjwLOvs5A9g--
