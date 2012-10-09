Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754586Ab2JICrv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 22:47:51 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55740 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753594Ab2JICru (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 22:47:50 -0400
Date: Tue, 9 Oct 2012 13:47:37 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Kees Cook <keescook@chromium.org>
Cc: paulmck@linux.vnet.ibm.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] make CONFIG_EXPERIMENTAL invisible and default
Message-Id: <20121009134737.cd3da4d85beeb97b1cb88d92@canb.auug.org.au>
In-Reply-To: <CAGXu5jLZH=VNU=ZaJRzFJxERBJEV1XkUfAqWK+6j8knOzua_Gw@mail.gmail.com>
References: <20121002195042.GA16087@www.outflux.net>
	<20121003132538.GE13192@linux.vnet.ibm.com>
	<20121003161702.GA22008@kroah.com>
	<CAGXu5jL6N2qSokXFr17Re9DOneWx-+seSx7k_dk-A+0mgbOejQ@mail.gmail.com>
	<20121008235344.GC8157@kroah.com>
	<CAGXu5jLUpcd-g0OM0i_1O38QWCWmw=PNfobtaLm0XduY45Ou6Q@mail.gmail.com>
	<20121009012610.GA3446@linux.vnet.ibm.com>
	<CAGXu5jLZH=VNU=ZaJRzFJxERBJEV1XkUfAqWK+6j8knOzua_Gw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__9_Oct_2012_13_47_37_+1100_JWuhZ3ida3DPgnOI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__9_Oct_2012_13_47_37_+1100_JWuhZ3ida3DPgnOI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Kees,

On Mon, 8 Oct 2012 18:57:51 -0700 Kees Cook <keescook@chromium.org> wrote:
>
> On Mon, Oct 8, 2012 at 6:20 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Mon, Oct 08, 2012 at 05:46:08PM -0700, Kees Cook wrote:
> >> On Mon, Oct 8, 2012 at 4:53 PM, Greg Kroah-Hartman
> >> <gregkh@linuxfoundation.org> wrote:
> >> > On Mon, Oct 08, 2012 at 03:08:40PM -0700, Kees Cook wrote:
> >> >> Who is going to carry this initial patch, btw?
> >> >
> >> > You?  :)
> >>
> >> Do you mean to say I should ask Stephen to pull from one of my trees
> >> for linux-next? If so, I've made this now:
> >>
> >> git://git.kernel.org/pub/scm/linux/kernel/git/kees/linux.git linux-next
> >
> > Sounds good to me, good luck.
>=20
> Stephen, can you add this tree to your pulls for linux-next?

For this single commit, if you want it to go in during this merge window,
I suggest you send it as a patch to Linus.    If there is going to be
ongoing work on this topic, then I will be happy to add your tree after
v3.7-rc1 is released (since the further work should be destined for v3.8,
right?).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__9_Oct_2012_13_47_37_+1100_JWuhZ3ida3DPgnOI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQc5BJAAoJEECxmPOUX5FEGnIP/1dKlExOj10elZ+uzeAJbGD5
aWOw8+tQCMEVn1mo0tON+UKEyWQ1RekF4Ul/jRq3BobFSZ64rDThr+iaLTTl+cJL
qGBnXZqN5H6468Hmnbf2bj2X3abOwuCr1ipFztdcVemvejvJ2OWPwG+BSGv+5zCR
zfbH7lglOKukvqmg7NOMaEGZLUmvhutNw65dz8sjCdOmxvdxvcfzaNpioBpEGvU3
P/FsULQ7v2fvsAw7vBb3DoSd67Er4sU0+bgPUnf67EiHW1eJdkRnMb7nSGMpenFb
+VKsLrsGz3Jp/0+Kg6mirEHueGuQnrbYs6+iOGqQ0R/9eWqv2SoyYln3UhmmM98N
7+/eVp1EkY6NczwjeA7Sn7YP80QyBC8FAgn7xyjf/wFJSGIkwYXw9hoVLc31j5zF
X9NkjT1qtSi8c9bunmPXnks6LL3GEjGBS23sNqqUdIHbcOjDqXgq8f7ZVitFB9dv
UI+WlKdVX9lQ/A+gR01nbsqa7fIqfKVqoEWtuF10o8aLv4bXDrn3HqkVT7o0sI+U
U/X6zdIGHyPMXWZr7OQ1PLsKPgs4yiRSSruQs92e3ZmfrnGfGg1old2YJ0r/ytjB
3G+moQBWrH4mD2eOsIckfAMgdLUkVRlvi6X38NzgFR3zJhf1FTpvhUmRxW52eD02
NsBRY5+LdbP74bmhtstS
=g4fP
-----END PGP SIGNATURE-----

--Signature=_Tue__9_Oct_2012_13_47_37_+1100_JWuhZ3ida3DPgnOI--
