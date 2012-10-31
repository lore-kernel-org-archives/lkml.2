Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab2JaPN1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 11:13:27 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:38290 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422889Ab2JaPNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 11:13:23 -0400
Date: Wed, 31 Oct 2012 17:07:17 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
CC: Michal Nazarewicz <mina86@mina86.com>, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <sebastian@breakpoint.cc>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Rothwell <sfr@canb.auug.org.au>, <linux-next@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb/gadget: let file storage gadget select libcomposite
Message-ID: <20121031150717.GB26934@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <xa1tfw4ug5so.fsf@mina86.com>
 <Pine.LNX.4.44L0.1210311106530.1954-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="eJnRUKwClWJh1Khz"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1210311106530.1954-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--eJnRUKwClWJh1Khz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Oct 31, 2012 at 11:07:44AM -0400, Alan Stern wrote:
> On Wed, 31 Oct 2012, Michal Nazarewicz wrote:
>=20
> > On Wed, Oct 31 2012, Felipe Balbi <balbi@ti.com> wrote:
> > > nevertheless, I should be receiving a patch right about now removing
> > > that file. Alan, care to send a patch for that ?
> >=20
> > I have some other stuff to remove as well, so I can take care of it, so
> > Alan can spend his time on something more important.
>=20
> I'm happy to have Michal remove g_file_storage.  That way, he gets to=20
> deal with any complaints.  :-)

heh, good point :-)

--=20
balbi

--eJnRUKwClWJh1Khz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQkT6lAAoJEIaOsuA1yqREyooP/3lKwhvvELi2XQX7UX1ph+tx
RAGRPSO3Pc4R+C5Y+MlRS+bupjcMxbVvu/uVgEmFhB24TzJCzIqEC2sbQRqjcZ/W
j/DHV5VluPOeclmbfZSQg3T4e51IhezRHVl0lAvvZsfxY5U3TkrzbFBm3egVfMzZ
yqhb1bKGHQOXBzZBvbI0Fu/3zuDE3p2Tw7cSSzTOrBLVoIxvI/9mbyTyXt+7/5gH
gLS7rS6A8Np+r/StJVFXpCgheyskxpTqMQSqS01t3waUrjVw72op5rTgd3VnGQv1
HtZ41C5fjUnqbE72anpF0SggBrFiyG5ZL3rqgSvF0Qn0c5mmOwtN8tYs9qYxIV6m
tykm8x7jNlE+11ohe8TwPHIQ4jDa9C+bMhbs9OyERgcSIKPsmtXI8EPlVAZ0C1X+
33K9N8IZMl6iHabzDUlCyo6t1xWNMt3WhyxnEooYDEqCAe9ZxLA1rhViWIe7NNIp
K4/c8kU1H4Sz6xEwEmye1aGZ2SQUx+6UcPfdJTbhyBUhrVPy/XlLY6I0miC3ewS3
dnGUoWmLR2XFVGvwLitaQR+IicHYuoleQOl3a0QXKqmOrNH4gRSyFNDkzAtimzml
SVJTHho0CePJ9qY4zogOZ2PZ58uTXmjKQ7b7gjrBc8o1HGFRzgq9mTBFAnnpmIau
T41TwXzIxn7oQ6cRFYfm
=cvy/
-----END PGP SIGNATURE-----

--eJnRUKwClWJh1Khz--
