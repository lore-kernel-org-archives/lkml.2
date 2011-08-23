Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751683Ab1HWG6z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 02:58:55 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:33984 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750712Ab1HWG6x (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 02:58:53 -0400
Date: Tue, 23 Aug 2011 16:58:41 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Pekka Enberg <penberg@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-next@vger.kernel.org
Subject: Re: linux next: Native Linux KVM tool inclusion request
Message-Id: <20110823165841.42cbced7ca56a14a41779ae1@canb.auug.org.au>
In-Reply-To: <CAOJsxLEgm_-N6297kHqSjFLCtX-Vd204S=+4Q=+GW9HYiWj1eg@mail.gmail.com>
References: <1314044960.3668.9.camel@lappy>
	<20110823003925.GA30253@infradead.org>
	<CAOJsxLEgm_-N6297kHqSjFLCtX-Vd204S=+4Q=+GW9HYiWj1eg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Aug_2011_16_58_41_+1000_qwVTFByg.XkbR/NL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Aug_2011_16_58_41_+1000_qwVTFByg.XkbR/NL
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Tue, 23 Aug 2011 08:08:02 +0300 Pekka Enberg <penberg@kernel.org> wrote:
>
> On Mon, Aug 22, 2011 at 11:29:20PM +0300, Sasha Levin wrote:
> >> I would like to ask you to include the Native Linux KVM tool in the
> >> linux-next tree.
>=20
> On Tue, Aug 23, 2011 at 3:39 AM, Christoph Hellwig <hch@infradead.org> wr=
ote:
> > What has changed over the last rejection of it? =C2=A0Again, I'm not ag=
ainst
> > the tool, but there is no reason to throw it into the kernel tree with
> > a completely misleading name.
>=20
> Linus didn't reject it but postponed his decision to the next merge
> window. We're going to send a pull request for 3.2 so we'd like the
> code to be in linux-next.
>=20
> As for changes, we've implemented rootfs over 9p with "kvm run"
> booting to host filesystem "/bin/sh" by default. It still needs some
> work and we hope to enable networking too. We also have patches to use
> overlayfs so that the guest is able to use host filesystem in
> copy-on-write manner.

I will add this to linux-next tomorrow unless people object by then.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Aug_2011_16_58_41_+1000_qwVTFByg.XkbR/NL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOU0+hAAoJEDMEi1NhKgbsr58H/0BBr/sDzHwLuhw4OQDaEZKr
8A5y3guP5Zn6uOPSUR7xgtuDI4eDLxLac+cTSEdoCKrRL1l610xBSX+YyzkIjPSr
l1hDtlRvJpDaySeEZmsmrt6AsESHFpsTrAh1X5E02wCntMiPJ4y9CRfIfW8QPlQ7
aTBBgLrIsRgRFdO/5WzeZ9J2N8Hq1BTP51kS/MmLltp02X35CHBtSBcpG4C6i4WP
Wnpx32L6HdfkOWRNhNa3odrdDt/++NkXnI9MkNOZqaHP+SsXCqr1d6x/4A4587dL
W+TIrrSiw7Q/toU9+Y/UenJ45BGUSel4KgFjAzW5MJC+7GXVe2kTB9R9hxG4ygY=
=vd6z
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Aug_2011_16_58_41_+1000_qwVTFByg.XkbR/NL--
