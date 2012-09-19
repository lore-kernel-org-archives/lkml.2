Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab2ISFjb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 01:39:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56643 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2ISFja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 01:39:30 -0400
Date: Wed, 19 Sep 2012 07:39:24 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: NeilBrown <neilb@suse.de>, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Benoit Cousson <b-cousson@ti.com>, Felipe Balbi <balbi@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] mfd: twl: Move PWM driver to PWM framework
Message-ID: <20120919053924.GA611@avionic-0098.mockup.avionic-design.de>
References: <1347279020-15596-1-git-send-email-thierry.reding@avionic-design.de>
 <20120919002459.GC3647@sortiz-mobl>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jRHKVT23PllUwdXP"
Content-Disposition: inline
In-Reply-To: <20120919002459.GC3647@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:T1J3L4zkNLTe9tYirgWXi/tFgCWWkvCsFcABjAOuFzA
 +9wy9o9dUkzoSRVRc1uXsp3DJjmySG2DYb0uuYldaJYUWnkm3I
 MkzKkj6CpzwOsDzC2zWH4col17dbYZfIpN1V6Nn8ibloB58NhX
 aEi0NdukMexG1bVLzsk9ciaXoFSZw726qNwtpYmUxbxMsTpCjW
 KLa6H3G0xGw98ubBENwBEm11xn0pzQtNEix9zzHHAqSRF07FwM
 9tz/i3f9q9i/GVwEugwuAoEqm9ZeccAzy/Ry+NXcl+UIqYpoxd
 qIrTYbxiUEKK1IyEuC3fTcU5NsJFbTiJ2u0Sj2z55LZXV/yZ2L
 YiTZwEuHFjMt18YMjay2Cfum9B/QljnNzWU+OwL1js7dheF0G0
 NenK5oh4ef3POmHC2aonTUoedBjYAsgKFE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jRHKVT23PllUwdXP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 19, 2012 at 02:24:59AM +0200, Samuel Ortiz wrote:
> Hi Thierry,
>=20
> On Mon, Sep 10, 2012 at 02:10:18PM +0200, Thierry Reding wrote:
> > Hi,
> >=20
> > This mini series replaces the twl_has_*() macros by the equivalent
> > standard IS_ENABLED() macro and moves the PWM driver to the PWM
> > framework.
> >=20
> > I'll take the second patch through the PWM tree but would like to have
> > some Acked-bys from people that know and have the hardware and can
> > verify that I haven't broken anything.
> We're already going to have conflicts for twl-core.c as Tony is pushing s=
ome
> code for it through his tree. So, would you be ok with me carrying the wh=
ole
> series through the MFD tree ?

Yes, that's okay with me.

Thierry

--jRHKVT23PllUwdXP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQWVqMAAoJEN0jrNd/PrOhCU8QAKSvZuhpp+MYpdAwyXuHeUjS
CNavmRzCaPty/kzxsna8Fv3l/tBNASNaY8TIaeO682TxW5nR95x3SMUW2uytQtbt
I2R0PRM/ezTdtcdN00l0knOxbwT+1gX+XphysmGAkGM4fM1nD85TsWbpU9T+yPMy
VL15xLXStqzJnYRbtQGNA//7CqU1fv9KR1ks4bXyCV4JQxiJHC0tEjmthilpWyYJ
7qBnWhptwG9Ua2xpBhTN+qGck/vg8H+ANMUDZePv5fWVunrkbjY8fDlutZmixmf1
+G573RcaSxvy/VXI5mNDKWGmXkP/y1PR1ct+mdYjR7ki/uTu2B0jAOuFM2F8rBwC
7t+oOArMZSbBqDDbWnGgFoeTobXxcq7D8CzaAf/ZQ/21GJtek80RmcKq1epOQO2X
IP0pp9xy6JswwA5hVyBK0zMMVLfBjqT6dXPGoogWfJv7aOx1lx3QHUYH6nHOq+fp
G768qHbwqotFcbQ0fz+W1iEwmcFlezisE3wt0HXv0uZ6ioFA2nT5bcEkP+3cbsse
lANEnZVD09e6NUVLv4dLFhTnZ55t7dIYv/yOGH3UomLA2fhBl3N+HHc8/Nq4T9Ct
v7VcWMiWVgOzJynj+hTgUAs5sNUpzuyTnSA4nQl7iC3uwPhxDzbH/6PQZejzdzyX
5908C3I7do/5OB4uVrM5
=DHwI
-----END PGP SIGNATURE-----

--jRHKVT23PllUwdXP--
