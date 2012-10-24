Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933756Ab2JXAjx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 20:39:53 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33899 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933692Ab2JXAjw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 20:39:52 -0400
Date: Wed, 24 Oct 2012 11:39:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kees Cook <keescook@chromium.org>
Cc: David Miller <davem@davemloft.net>, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH 173/193] net/mac80211: remove CONFIG_EXPERIMENTAL
Message-Id: <20121024113941.bbc15e2f317f4307706fae7a@canb.auug.org.au>
In-Reply-To: <CAGXu5j+wRzsYy1WWo5tbffz6p0hnRAkS+DV3Jv1e35ppGFrchA@mail.gmail.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-174-git-send-email-keescook@chromium.org>
	<1351023350.10322.21.camel@jlt4.sipsolutions.net>
	<20121023.161630.969990145069865276.davem@davemloft.net>
	<CAGXu5j+wRzsYy1WWo5tbffz6p0hnRAkS+DV3Jv1e35ppGFrchA@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__24_Oct_2012_11_39_41_+1100_pDo8MfRh44tj2/0o"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__24_Oct_2012_11_39_41_+1100_pDo8MfRh44tj2/0o
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi All,

On Tue, 23 Oct 2012 13:22:23 -0700 Kees Cook <keescook@chromium.org> wrote:
>
> On Tue, Oct 23, 2012 at 1:16 PM, David Miller <davem@davemloft.net> wrote:
> > From: Johannes Berg <johannes@sipsolutions.net>
> > Date: Tue, 23 Oct 2012 22:15:50 +0200
> >
> >> On Tue, 2012-10-23 at 13:04 -0700, Kees Cook wrote:
> >>> This config item has not carried much meaning for a while now and is
> >>> almost always enabled by default. As agreed during the Linux kernel
> >>> summit, remove it.
> >>>
> >>> CC: "John W. Linville" <linville@tuxdriver.com>
> >>> CC: Johannes Berg <johannes@sipsolutions.net>
> >>> CC: "David S. Miller" <davem@davemloft.net>
> >>> Signed-off-by: Kees Cook <keescook@chromium.org>
> >>
> >> Acked-by: Johannes Berg <johannes@sipsolutions.net>
> >>
> >> Presumably somebody is going to submit a git tree with the entire seri=
es
> >> and you don't want me to pick up this piece, right?
> >
> > He better not expect us to take this stuff.
>=20
> I'm going to do whatever each maintainer wants. :)
>=20
> Sounds like you guys would like me to carry these in my tree, so I'll
> add them to linux-next.

I would much prefer that they are merged via each maintainers tree as that
will eliminate the inevitable conflicts (for which I will bear the
pain :-().

These are not big hard patches and have no dependencies on anything, so
what is the problem?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__24_Oct_2012_11_39_41_+1100_pDo8MfRh44tj2/0o
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQhzjNAAoJEECxmPOUX5FEkSwQAILTnEalwssOKd6tK8OTnMkr
nQMzv0amRTgJdS5YGsg0nmfhU+62nXNdkkmPqfrQjM/UOGzSoyc89y2z9VsAZ41G
ei5Z9WOx06GrFbPCgepx12fpmo3tc19zXlczcsMr1WXWHJKoaYPK9FeEY75Sa0FX
aaZHRyrALwKqAaFQyMlZeqGV07mL2yiuZpogQ+KlhxjbZsPhA3ppaNmxxvi4lbV0
jhcIulHruN5Vcbp0PEorDrEQDyKMqCDWXSyJpzrN+wYYe5Ar1kHmEQvKZElOyDko
u9ykHo1CR2EJFowlnyOWrU6+5MZm70gih81AFm2jKQUUHtCqSMWPLJ+4oL9tgDNM
gMVEQjjtQ2/js7Yv4XrjtBFZ1iSeXNdlxJ7wyFjKERzjepgrpMO9dxyJJrXBxPFk
sKFc35XLYgq4SWanSv3+UcfosQl8lANm8rzpAamFSdEmX7ifJl48UFKnO+XFctRr
sMQ9QOxoFzvarDszVao8njd/E4ajxSV5O90ekk2gMBFyUPR44su5P6tWr6DKEtFD
lLWBjo4Gk5D8sx2EJP0WNVY2apcuOU3f/FHtIFn+O95szNcY8n8uhtH1V9h2IQKr
y/u4chE8twDBb77GEm3rtQNGJ5niKL8AnhjxCMi2IZZZVGUFrS/JdFu1eXlOI8D7
1dKkCpuLiieJMA0oVtjB
=nI8j
-----END PGP SIGNATURE-----

--Signature=_Wed__24_Oct_2012_11_39_41_+1100_pDo8MfRh44tj2/0o--
