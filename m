Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754648Ab1KBG0g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 02:26:36 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:34220 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752504Ab1KBG0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 02:26:35 -0400
Date: Wed, 2 Nov 2011 09:26:51 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: devel@driverdev.osuosl.org, Paul Bolle <pebolle@tiscali.nl>,
        Ciaran McCormick <ciaranmccormick@gmail.com>, gregkh@suse.de,
        linux-kernel@vger.kernel.org, shemminger@vyatta.com
Subject: Re: [PATCH] Stageing: bcm: fixed spacing coding style in
 led_control.c
Message-ID: <20111102062651.GE4682@mwanda>
References: <1320144259-22339-1-git-send-email-ciaranmccormick@gmail.com>
 <1320145665.14409.149.camel@x61.thuisdomein>
 <20111101202259.GC4682@mwanda>
 <1320202495.15779.11.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="19uQFt6ulqmgNgg1"
Content-Disposition: inline
In-Reply-To: <1320202495.15779.11.camel@Joe-Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4EB0E28E.00ED,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--19uQFt6ulqmgNgg1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 02, 2011 at 04:54:55AM +0200, Joe Perches wrote:
> On Tue, 2011-11-01 at 23:22 +0300, Dan Carpenter wrote:
> > You're right that this driver needs a lot of work.
> []
> > I'd prefer a series of patches:
>=20
> Thanks Dan, that's a good summary of useful changes
> and their best order.  Couple of comments:
>=20
> > [patch 1/3] Staging: bcm: fix whitespace in led_control.c
> > This would address tabs vs spaces, extra prohibited spaces, and
> > spaces required around certain chars.  Also it would add blank lines
> > between functions and between declarations and code.
>=20
> And verify with git diff -w and object diffs.
>=20

How are you doing the object diff?  I've tried just using diff
against the object files but the line number changes mess everything
up.

regards,
dan carpenter

--19uQFt6ulqmgNgg1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOsOKqAAoJEOnZkXI/YHqRIwgQAKbKT5raImQ+9Ti0i5Rkq8Sd
R7KK3h1A3H8rrYnQxqUZFquknDzgo0Jsyy4LGieRpLdk5huZqPwkY4VXxM8eCJGU
6ou1JzUWNRNqQX7a6XIthxHndKZVhOsAOywOsdtTCoQLWzWpl/g5FU4unGXAtZzD
3bDLrW/kZrT1bUuLrc2kjcZmqJKJ+Fl58nmLxBpW1YJ7eahfwMknjMDAOsOKYHR2
/xQyEbEPfyNdQbiLCZBDQ+lYIH5SxzSkWlP7lp9Ey4bMRq3DHE4c3KGlxo5Sh9ao
nc9y/aHfbySjH8HhDMKcOQzk3KclSXGavzrJJZXaReWjaztUkQKPdJCMECjs8yr2
v1QNW4PXCA0C/8qAaL8lWf3lMUf5XJm4CBghokUM2q8ETdEYL/28BSESoWA6y6si
wREe7K4Pe0iMTWmHzYVCpE070Zel0y3U949169R/Zagafh5SDwQfswTin/GzOt+l
mnstMUEMQFws53j3jwXx67f6Ti2VnQwbVwFYdfNL4cW4Ji3vT84exrxRTGK+/Rct
WvEFDqgwgcZ55cMhSlK/bIj7Flc2xkjHx501bRyOpWtBWOG99dVuRW0cKIWbw6AS
yoXmv2hP7QBwnp35og6ruZwoTPZXREUcVqzwUsxf5k3oMziU4YamP7NLFstwgwa2
qybmUsiMKouy/6Q7kFxl
=JB+f
-----END PGP SIGNATURE-----

--19uQFt6ulqmgNgg1--
