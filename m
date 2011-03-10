Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab1CJQ7T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 11:59:19 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:65036 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751329Ab1CJQ7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 11:59:18 -0500
Date: Thu, 10 Mar 2011 11:59:12 -0500
From: Eric B Munson <emunson@mgebm.net>
To: Paul Menage <menage@google.com>
Cc: containers@lists.linux-foundation.org, rdunlap@xenotime.net,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Documentation: cgroups: Add notes on removing PIDs
 from tasks and cgroups requiring setup
Message-ID: <20110310165911.GA4911@mgebm.net>
References: <1299704969-4485-1-git-send-email-emunson@mgebm.net>
 <AANLkTinW99M1FBp5gRA=+SsjUWSJBwByurqrsjXKgQ4=@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="45Z9DzgjV8m4Oswq"
Content-Disposition: inline
In-Reply-To: <AANLkTinW99M1FBp5gRA=+SsjUWSJBwByurqrsjXKgQ4=@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--45Z9DzgjV8m4Oswq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 09 Mar 2011, Paul Menage wrote:

> On Wed, Mar 9, 2011 at 1:09 PM, Eric B Munson <emunson@mgebm.net> wrote:
> >
> > +Note: To remove a task from a cgroup you must write its PID to the root
> > +tasks file.
> > +
>=20
> This isn't really accurate - the root cgroup is a cgroup like all the
> others. More accurate would be something like:
>=20
> Since every task is always a member of exactly one cgroup in each
> mounted hierarchy, to remove a task from its current cgroup you must
> move it into a new cgroup (possibly the root cgroup) by writing to the
> new cgroup's tasks file.
>=20
> Paul
>=20

I am going to lift that for V2.

--45Z9DzgjV8m4Oswq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNeQNfAAoJEH65iIruGRnNuxsIAIXMHywzVAuCywb3SOLhXTXJ
r/0Z+t6Tlmy1mSh701GU+t2TPl/Cr4UwN0xHmBVtBGBUFKXzXibmatsVLavD/r5K
Zjosn5nhKpwiXH0RmWSiGlCLgr6qkhUpRuujOnf993+81omUjCfLfLUzbaS9p5FD
4taE8seaUUUoZromdh1mtEwIR9gdYtKG1obuCCuhaI4R+esHMVS/kMQYHt0zxEhW
8o1lvQV5xvGDpYrluj+hAquU+7l0fhmHsHMQhv96fq/X24puEB7K1yxgBMg+vwr2
i7KNBDPdXwsZdFXJRC/C2LCN0iK1pkA7EfMPi0Cg/tjv1hr9fyZgtYZp6Lw3Nqk=
=dAUN
-----END PGP SIGNATURE-----

--45Z9DzgjV8m4Oswq--
