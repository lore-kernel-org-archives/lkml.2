Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754590Ab2ADJA6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 04:00:58 -0500
Received: from sunflower.ift.uni.wroc.pl ([156.17.88.33]:57824 "EHLO
	sunflower.ift.uni.wroc.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab2ADJA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 04:00:57 -0500
Date: Wed, 4 Jan 2012 10:00:52 +0100
From: =?utf-8?Q?=C5=81ukasz?= Michalik <lmi@ift.uni.wroc.pl>
To: Denys Vlasenko <dvlasenk@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Denys Vlasenko <vda.linux@googlemail.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        "Dmitry V. Levin" <ldv@altlinux.org>
Subject: Re: ptrace fixes for 3.2
Message-ID: <20120104090052.GA24624@havoc.ift.uni.wroc.pl>
References: <201112281955.55200.vda.linux@googlemail.com>
 <20111229113245.GA18062@redhat.com>
 <20111229120506.GA23653@redhat.com>
 <20120103142941.GA25488@redhat.com>
 <20120103154404.GA28930@redhat.com>
 <4F033227.3020404@redhat.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qMm9M+Fa2AknHoGS"
Content-Disposition: inline
In-Reply-To: <4F033227.3020404@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qMm9M+Fa2AknHoGS
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 17:51 2012-01-03 +0100, Denys Vlasenko wrote:
> On 01/03/2012 04:44 PM, Oleg Nesterov wrote:
> >On 01/03, Oleg Nesterov wrote:
> >>
> >>I am going to send the hack^Wpatch below to Linus as a temporary
> >>workaround for 3.2.
> >
> >The same patch with the changelog.
> >
> >Denys, Tejun, any chance you can review it before I send it to Linus ?
>=20
> Testing it on top of Fedora 16's kernel-3.1.6-1.fc16:
>=20
> Confirmed that before patch both tests fail (in about a minute of run time
> at worst), and with patch they do not fail.
>=20

Tested on top vanilla's HEAD and stable 3.1.7, with both testcases and
both strace and sydbox.  Confirming same as Denys.

--=20
Pozdrawiam,
=C5=81ukasz P. Michalik

--qMm9M+Fa2AknHoGS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iEYEARECAAYFAk8EFUQACgkQ2Du0fXZKF/XGTwCg1k/eiLIoWhgHpJaaGH1n/Im8
hSYAn3ZMLTJvdai/N82O60788M+POPTt
=DHOc
-----END PGP SIGNATURE-----

--qMm9M+Fa2AknHoGS--
