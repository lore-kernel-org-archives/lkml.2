Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab0DTW6Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 18:58:25 -0400
Received: from mail.copilotco.com ([216.105.40.123]:52710 "EHLO
	mail.copilotco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756Ab0DTW6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 18:58:24 -0400
Date: Tue, 20 Apr 2010 15:58:23 -0700
From: Tracy Reed <treed@ultraviolet.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>,
       xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
       Aoetools-discuss@lists.sourceforge.net
Subject: Re: [LKML] Re: [Xen-devel] domU is causing misaligned disk writes
Message-ID: <20100420225823.GX5660@tracyreed.org>
Mail-Followup-To: Tracy Reed <treed@ultraviolet.org>,
	Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
	Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>,
	xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
	Aoetools-discuss@lists.sourceforge.net
References: <20100420080958.GN5660@tracyreed.org>
 <20100420084955.GV1878@reaktio.net>
 <20100420085436.GW1878@reaktio.net>
 <20100420184038.GB32720@phenom.dumpdata.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="j4ivd53YxxNwCQqF"
Content-Disposition: inline
In-Reply-To: <20100420184038.GB32720@phenom.dumpdata.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--j4ivd53YxxNwCQqF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 20, 2010 at 02:40:38PM -0400, Konrad Rzeszutek Wilk spake thusl=
y:
> .. and you failed to mention how you disk is setup to the guest. Are you
> setting it up via phy://dev/ether!d or are tap:aio or
> phy://dev/mapper/VG-LV ? Try to make it only via phy:// as that
> eliminates the Dom0 cache and any userspace program (blktap) from
> being in the picture.

Disk is set up like so:

disk =3D [ "phy:/dev/etherd/e1.28,xvde,w",
         "phy:/dev/etherd/e2.28,xvdf,w",
         "phy:/dev/etherd/e3.1,xvdc,w",
         "phy:/dev/etherd/e4.1,xvdd,w",
         "phy:/dev/etherd/e6.1,xvdg,w",
         "phy:/dev/etherd/e6.2,xvdh,w" ]


--=20
Tracy Reed
http://tracyreed.org

--j4ivd53YxxNwCQqF
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFLzjGP9PIYKZYVAq0RAiKhAJ9oHlMR7zOerWx1wGpDQN+dwDn0SACfT7/J
/XFm87tq/XTef/ghuzHZ3GI=
=/vT8
-----END PGP SIGNATURE-----

--j4ivd53YxxNwCQqF--
