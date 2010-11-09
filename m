Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0KIBLY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 20:11:24 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:42003 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752388Ab0KIBLX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 20:11:23 -0500
Date: Tue, 9 Nov 2010 12:11:13 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ed Cashin <ecashin@coraid.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, sage@newdream.net,
        yehuda@hq.newdream.net, linux-kernel@vger.kernel.org,
        Tracey Dent <tdent48227@gmail.com>
Subject: Re: [Resend][PATCH 2/2] Drivers: block: aoe: Makefile: replace the
 use of <module>-objs with <module>-y
Message-Id: <20101109121113.956cc6e5.sfr@canb.auug.org.au>
In-Reply-To: <20101108130543.1188a63f.akpm@linux-foundation.org>
References: <1289069918-2085-1-git-send-email-tdent48227@gmail.com>
	<1289069918-2085-2-git-send-email-tdent48227@gmail.com>
	<EDA33B3B-F9C9-4C45-B20D-C985DFC95C2F@coraid.com>
	<20101108130543.1188a63f.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__9_Nov_2010_12_11_13_+1100_yxDeITk38C2XXF52"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Nov_2010_12_11_13_+1100_yxDeITk38C2XXF52
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ed,

On Mon, 8 Nov 2010 13:05:43 -0800 Andrew Morton <akpm@linux-foundation.org>=
 wrote:
>
> On Mon, 8 Nov 2010 10:03:24 -0500
> Ed Cashin <ecashin@coraid.com> wrote:
>=20
> > On Nov 6, 2010, at 2:58 PM, Tracey Dent wrote:
> >=20
> > > Changed <module>-objs to <module>-y in Makefile.
> >=20
> > Andrew Morton, hi.  I don't know whether Tracey Dent is expecting
> > me to push this change to Linus, but lately you've been pushing the
> > aoe changes.  I see similar changes in other
> > drivers on the LKML, so if it looks good to you, would you mind please
> > picking up this patch?
>=20
> I queued both patches - I guess I'll send them to Jens.

I have a quilt series in linux-next called aoe that has not been updated
since Nov, 2009.  Can I assume that it is defunct and remove it?  Or will
you be using it again?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__9_Nov_2010_12_11_13_+1100_yxDeITk38C2XXF52
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM2J+xAAoJEDMEi1NhKgbsW3kH/1ZodYn8mjUibxQHs9kOTLjS
SwavffvEcbgAJRKuf2LjZrWv3S48wE4RnPFaL97hOl2SeQA7mhuG36L9X0LKxIeB
M2teDGuYzJhKFo83L1w55aYK8q1SdlBVTF99D4bHHanOFzQwlQuVho7PX7Ztb5IO
dL+3CnfiNLCOArSgj3CI+SbyolU7tzzvO9ykITROe3AGtGKGquOwqtauBELMsv8E
xFfWpqM5W5B7kKkyOQnkL28wsr4tLTuKaAkUj89lNFfNc/vEIl/JGrhB3x09ZN0F
DHK1taR1MWJ+Kjb7oWnuhw+Pzy8aqKqRHJroTrCy6a0xhzX0S+9nYZRHtvcecHs=
=9H2N
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Nov_2010_12_11_13_+1100_yxDeITk38C2XXF52--
