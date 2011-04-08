Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753568Ab1DHI2l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 04:28:41 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:56152 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab1DHI2i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 04:28:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N/mTPPRDVhp9W82FSw6eVGJFrCYym6ALRR35zyaJPQ/7B4B31S7WyRl3JEeIAxY8yT
         ScS03nhaz75qLOrQtzbzdmVBfWL8mQttwC5ALpZPlMbbmEN8ixEub015JbIEEfnI2wy4
         enxjA3fqp3NN/649SLwrscwsQy8J/0tYjfAvQ=
Date: Fri, 8 Apr 2011 10:28:27 +0200
From: Martin Jansa <martin.jansa@gmail.com>
To: Zaurus PDA developers list <zaurus-devel@www.linuxtogo.org>
Cc: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        thommycheck@gmail.com, Cyril Hrubis <metan@ucw.cz>, arminlitzel@web.de,
        kernel list <linux-kernel@vger.kernel.org>, lenz@cs.wisc.edu,
        rpurdie@rpsys.net, eric.y.miao@gmail.com,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [Zaurus-devel] 2.6.39-rc2 on zaurus: does not build, does not
 boot
Message-ID: <20110408082827.GD3180@jama.jama.net>
References: <20110408062646.GA1472@ucw.cz>
 <201104080931.11202.marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GyRA7555PLgSTuth"
Content-Disposition: inline
In-Reply-To: <201104080931.11202.marek.vasut@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GyRA7555PLgSTuth
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 08, 2011 at 09:31:10AM +0200, Marek Vasut wrote:
> On Friday 08 April 2011 08:26:46 Pavel Machek wrote:
> > Hi!
> >=20
> > Build fix is below. Maybe it is pending in the trees somewhere
> > already...
>=20
> Fix is already there, it was broken by a patch from someone recently. Tha=
nks=20
> though
> >=20
> > Boot stops just after mounting root filesystem; cursor stops
> > flashing. (Any idea what goes on there?)
>=20
> No idea, it works for me and doesn't hang ;-)

it works here too with rev 6221f222c0ebf1acdf7abcf927178f40e1a65e2a

Cheers,

--=20
Martin 'JaMa' Jansa     jabber: Martin.Jansa@gmail.com

--GyRA7555PLgSTuth
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk2exysACgkQN1Ujt2V2gBwqkQCfYfE6/P+jPgTSy3PPp52DEASZ
tNgAoKqDX7Xva3oKwvWBKHqNg561Ylca
=euWS
-----END PGP SIGNATURE-----

--GyRA7555PLgSTuth--
