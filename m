Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752185Ab0INEcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 00:32:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:34489 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab0INEcF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 00:32:05 -0400
Date: Tue, 14 Sep 2010 14:31:59 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Renninger <trenn@suse.de>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <greg@kroah.com>,
        Jason Baron <jbaron@redhat.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the final tree
 (driver-core tree related)
Message-Id: <20100914143159.dca830f0.sfr@canb.auug.org.au>
In-Reply-To: <201009132126.14115.trenn@suse.de>
References: <20100907115426.fc0c3e13.sfr@canb.auug.org.au>
	<20100907023404.GA11972@kroah.com>
	<20100913085155.6b73c9cc.randy.dunlap@oracle.com>
	<201009132126.14115.trenn@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__14_Sep_2010_14_31_59_+1000_mNmsoJrePHf+t=Lf"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__14_Sep_2010_14_31_59_+1000_mNmsoJrePHf+t=Lf
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Mon, 13 Sep 2010 21:26:13 +0200 Thomas Renninger <trenn@suse.de> wrote:
>
> On Monday 13 September 2010 17:51:55 Randy Dunlap wrote:
> > On Mon, 6 Sep 2010 19:34:04 -0700 Greg KH wrote:
> >=20
> > > On Tue, Sep 07, 2010 at 11:54:26AM +1000, Stephen Rothwell wrote:
> > > >=20
> > > > After merging the final tree, today's linux-next build (powerpc
> > > > allnoconfig) produced this warning:
> > > >=20
> > > > kernel/params.c: In function 'parse_args':
> > > > kernel/params.c:233: warning: the frame size of 1032 bytes is large=
r than 1024 bytes
> > > >=20
> > > > Introduced by commit 32e6407e9361cd1aac39ff6b744cad48d1802a08 ("Dyn=
amic
> > > > Debug: Introduce global fake module param module.ddebug") which add=
ed a
> > > > 1024 byte array to the stack ...
> > >=20
> > > Wierd, why didn't this show up yesterday?  The patch was in that tree
> > > then, right?
> > >=20
> > > Thomas, care to fix this up?
> > =20
> > ping.  Is Thomas around??
> Yep, sorry for not responding.
>=20
> I tried to reproduce this on ppc64, but above file compiled without
> warning with dynamic debug set. Thus I thought this still came from the
> old patch.

The report is for a powerpc allnoconfig build (see above) i.e. ppc32.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__14_Sep_2010_14_31_59_+1000_mNmsoJrePHf+t=Lf
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMjvq/AAoJEDMEi1NhKgbsgr8IAJ2iXvcVhOnyMS9VN1YUJipB
45qFw9C+srXBg3lDJAZ3UdJX7QGpoQ+zH/vlqUVlZwScXX99sm4T2pb9ySNc02pB
HOhH9qP77e/syFD+dsOZqL4Lc+9cIU1Mmr+umtOxxNoHeXhUJ8bhd8dbJGzvuNq+
0kxVc6u5z/LAFC/37GX0sKLNauIEWq72t7Cu41AsJa0wZliIdLBaalFoW36TRjam
laE1Q0LzRCa1ct6nDzAbqcq+YrNbvOOYLYo+hEk/yp2kE/jcDiqGJ1qYxlzheUFn
lovfRakYMR1oC4HDnu5s0QBT0zqHOG/A3c+M2ULcXGNDiJPCTbS57ShsuHbwpPI=
=y7+H
-----END PGP SIGNATURE-----

--Signature=_Tue__14_Sep_2010_14_31_59_+1000_mNmsoJrePHf+t=Lf--
