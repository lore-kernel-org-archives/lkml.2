Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753620Ab2A0S5o (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:57:44 -0500
Received: from home.keithp.com ([63.227.221.253]:54701 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753055Ab2A0S5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:57:41 -0500
From: Keith Packard <keithp@keithp.com>
To: Lubos Kolouch <lubos.kolouch@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i915 wakes from suspend to RAM with blank screen after commit cd9dde44f47501394b9f0715b6a36a92aa74c0d0
In-Reply-To: <20120127101403.GA2213@nbgentoo.nlcz.cz>
References: <jfe47e$5dn$1@dough.gmane.org> <86mx9gkjlv.fsf@sumi.keithp.com> <20120121184453.GA2698@nbgentoo> <86hazokcb7.fsf@sumi.keithp.com> <20120122102912.GA2123@nbgentoo> <867h0j83vx.fsf@sumi.keithp.com> <20120123063313.GA2113@nbgentoo> <86vcnyc3t3.fsf@sumi.keithp.com> <20120127101403.GA2213@nbgentoo.nlcz.cz>
User-Agent: Notmuch/0.11 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Fri, 27 Jan 2012 10:57:06 -0800
Message-ID: <86liot9dod.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Fri, 27 Jan 2012 11:14:03 +0100, Lubos Kolouch <lubos.kolouch@gmail.com>=
 wrote:
> On Wed, Jan 25, 2012, 23:37:28, Keith Packard wrote:
> > On Mon, 23 Jan 2012 07:33:14 +0100, Lubos Kolouch <lubos.kolouch@gmail.=
com> wrote:
> >=20
> > > dmesg after boot - http://paste.pocoo.org/show/539115/
> > > dmesg after OK resume - http://paste.pocoo.org/show/539117/
> >=20
> > I've posted a couple of more comprehensive patches that you should have
> > received; I'd like to know if you can test them to see if they resolve
> > the issue as well.
>=20
> 1) applied the first patch, resume works OK
> dmesg after boot : http://paste.pocoo.org/show/541205/
> dmesg after resume : http://paste.pocoo.org/show/541206/
>=20
> 2) applied second patch on top, resume works OK
> dmesg after boot: http://paste.pocoo.org/show/541477/
> dmesg after resume : http://paste.pocoo.org/show/541479/

Thanks!

I'll append a 'Tested-by: Lubos Kolouch <lubos.kolouch@gmail.com>'

to these patches when they go into the kernel.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTyLzgjYtFsjWk68qAQjx8hAAjkcuSfj+DaHrxvlSGuAiB8KkITCwB2iS
Lt0Q3neRoF6H1OPBaB0JnX75uMaUhFlQD7lYe+GUQUORQpZP5OS8fvue5IAH+CRN
xIejXG81JiWUxbgP307fn/vjb32T44L2+eb/0U0t/XFfYvNTPcUVPcxog/xn5h1q
Kyfs/DLLLEQYDmVNdRVUhyBFfeJ7pubnOckgurfjhi9Mr2k6MLAo6dPVE6Hn68lz
7U89EdAgVVg7fLrp6R3MUMFWsvCsYuNmoQ7sCCFPhQYeJoRHMi2xwhulptoEg4Ve
CRKcA+mAOtmGxPl/T0Xye6CUw4oknJOzQuPJW7zUSk2aIBzf8QfrEj/UKspbhHQK
YPpx2WkBV+GFo60kqnK8DcQgn7ovOJx32FbLRPXvV2iRNed485f20ChiNkoTAKEL
GOWkeq0Zh08hnm8GNICB8RiTd/SBnrUZdZRUMNeUgh4HsRXYge9VeR7KtiZJo8fj
pXajvcE1l8FB6FwCRtcHfdVr2Hod8y5W5Il1ODvQh0pfEAwJblkiIhEQCd3BBXBP
CQdduM9KVRDdjR6WIVTTlFeK/BTCGegrIYIJAfBspTXNF/kRq99kMeTFmkM139dX
3DTBgqIb372rFCj+Xd7H7w54ZtmB5KiO0h2HmRvlYqtiMkis2OegAuYF2zB9Og9V
iCFH2DoTTZw=
=v0Va
-----END PGP SIGNATURE-----
--=-=-=--
