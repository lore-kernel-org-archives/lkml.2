Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756399Ab2IJDSg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 23:18:36 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48478 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755961Ab2IJDS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 23:18:27 -0400
Date: Mon, 10 Sep 2012 13:18:02 +1000
From: NeilBrown <neilb@suse.de>
To: Jan Engelhardt <jengelh@inai.de>
Cc: Miklos Szeredi <miklos@szeredi.hu>, viro@ZenIV.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, apw@canonical.com, nbd@openwrt.org,
        hramrach@centrum.cz, jordipujolp@gmail.com, ezk@fsl.cs.sunysb.edu,
        ricwheeler@gmail.com, dhowells@redhat.com, hpj@urpla.net,
        sedat.dilek@googlemail.com, penberg@kernel.org,
        goran.cetusic@gmail.com, romain@orebokech.com, mszeredi@suse.cz
Subject: Re: [PATCH 07/13] overlay: overlay filesystem documentation
Message-ID: <20120910131802.157d6a35@notabene.brown>
In-Reply-To: <alpine.LNX.2.01.1209100333290.22738@frira.zrqbmnf.qr>
References: <1345045700-9062-1-git-send-email-miklos@szeredi.hu>
	<1345045700-9062-8-git-send-email-miklos@szeredi.hu>
	<alpine.LNX.2.01.1209100333290.22738@frira.zrqbmnf.qr>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rqFg_b_8quJEgrvc1xyFgcD"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/rqFg_b_8quJEgrvc1xyFgcD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 10 Sep 2012 03:47:04 +0200 (CEST) Jan Engelhardt <jengelh@inai.de>
wrote:

>=20
> On Wednesday 2012-08-15 17:48, Miklos Szeredi wrote:
> >[...]
> >+This is most obvious from the 'st_dev' field returned by stat(2).
> >+
> >+While directories will report an st_dev from the overlay-filesystem,
> >+all non-directory objects will report an st_dev from the lower or
> >+upper filesystem that is providing the object.
>=20
> That would seem to render `rsync --one-filesystem` unusable?
> (or similar options in other tools)
>=20

Would it?  Have you tested? or examine source code? or just guessed?

I quick look at rsync and du suggest that you only consider --one-file-syst=
em
when looking at a directory - they assume files are in the same filesystem =
as
their parent.
I cannot promise that everything would work exactly as expected, but I
suspect most things will..... though that might  depend on your expectation=
s.

NeilBrown

--Sig_/rqFg_b_8quJEgrvc1xyFgcD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUE1b6jnsnt1WYoG5AQKQsA//ZEKy6kup0CVOhc7FIzqmFTht8doAFz8r
RmPU0P5N2VyEazScCec61nj90HH1IMj7QIy3VZIa4TEYfDrfSMPfpa+Y+PU+BNew
aj/hI874gzI6Nab8Nb2IP6jT3D60UppnpwTPqVvC5NEUVxCf1tw30zVv4/9dqSUL
bFJuknmjoJDsNGFZ/lXIJkCdyCwVCg/ra7LI4lgrImaGMA24Q3NmjhjQ3D3kl9yF
ZAHLbqb2S32O2c3q6IM06ZtHOq4++1yHHC7+v6jJ+lhAufiXsq46LSDzOnG23NDI
dLRGbn5H6fTJ60d/T6MM7GAVYZsUyEcFmdsdqdcO68cCkNp71RXvuRbNir+C5p6E
klcxVPlo2rNeP2C3QVv52VXNiU2ERbpeZG94DHOTrAwQQm5Ew4waRL/vXS+i/s85
yeTAs1XDJGVWIrBojl7ifPYlgCoaOdjkUl12+b2cc0aEkqPdnY7A4xJOvsjDnTxi
Ne/oX5Dis3rYyVxXlRPnmaPuHDVKDbxlnQhQczWEeiLpgnBTUZhBiXF3QX0fM2h1
nE8dNj+UjPn+Iazo2anoEACgZEGjFoWL8YFLcZhBlHUlOlIa+0aP5vYIDNerIi7z
ZHmdfr1qevqqZdksn8dRDm7yle6m3DQgNjVbyWhMmy8jYvjC1Ip5NpgkhuHLqHQ8
VOmZPe9aZwo=
=rs9y
-----END PGP SIGNATURE-----

--Sig_/rqFg_b_8quJEgrvc1xyFgcD--
