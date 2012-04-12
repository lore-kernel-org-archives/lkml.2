Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762143Ab2DLHxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 03:53:15 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:33083 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751193Ab2DLHxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 03:53:14 -0400
Date: Thu, 12 Apr 2012 10:52:23 +0300
From: Felipe Balbi <balbi@ti.com>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: gadget: f_mass_storage: remove deprecated fsg_add()
Message-ID: <20120412075221.GB24833@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1ad5f25435fc5d2cd094ae1c68d7831b8b2737ca.1331896818.git.mina86@mina86.com>
 <op.wa9go4093l0zgt@mpn-glaptop>
 <20120411094112.GK12064@arwen.pp.htv.fi>
 <20120411152528.GA27947@kroah.com>
 <op.wcl9dbyh3l0zgt@mpn-glaptop>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qcHopEYAB45HaUaB"
Content-Disposition: inline
In-Reply-To: <op.wcl9dbyh3l0zgt@mpn-glaptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--qcHopEYAB45HaUaB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 11, 2012 at 09:49:49PM +0200, Michal Nazarewicz wrote:
> >>On Fri, Mar 16, 2012 at 12:25:42PM +0100, Michal Nazarewicz wrote:
> >>>From: Michal Nazarewicz <mina86@mina86.com>
> >>>
> >>>There are no in-tree fsg_add() users and it has been deprecated
> >>>since 2.6.35 [1dc90985d1: fsg_add() renamed to fsg_bind_config()] so
> >>>out-of-tree users had more then enough time to convert.  Removing.
>=20
> >On Wed, Apr 11, 2012 at 12:41:13PM +0300, Felipe Balbi wrote:
> >>applied, thanks. Also added your SOB, next time be more careful.
>=20
> On Wed, 11 Apr 2012 17:25:28 +0200, Greg Kroah-Hartman <gregkh@linuxfound=
ation.org> wrote
> >Um, wait, you can't just "add" a SOB, that's not allowed at all, sorry.
> >
> >Michal, do you sign-off on this patch?  If so, please do so.
>=20
> Sorry, yes, of course.

I think you need to be more verbose and reply with the actual
Signed-off-by: line

--=20
balbi

--qcHopEYAB45HaUaB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPhom1AAoJEIaOsuA1yqRESKYP/jp/U0YlVAwi1N+ha41CvNtl
hnPmx91tVhL8EJF3h+qf6pN9R7MplHFrXBc3o8SOOqQNoZ1C/N95TxN8M7dwWFdu
+FUj1zhgyyzrwJfgU1VVMeHO9DHOVsnUxuHDBmxj7Dv1uzeqLzzfE18YIVdZn6Qk
Vb9Djc/sXdioU7N74CD1mw6hcasdR1GojdlZZYy66NgW4qRyZj624f9boOkB5sfC
db4f55u6smhTaJXDn0MiD1PWZKtgkoONCah+YzaO6ziqAY5yOa3xBzeVOF984wUR
3kfNwL8XRJC+wsxRcR8JDJGDm2aP9olTWouZLNkhDPYvLgZsqCCnD5uBXW6ymb31
/Kx941luy8gKKBkjC48phXcdOjPwGMtIpUnETRi0+IrzH/ilLqthtV5yIupC81UD
glVfcw7SPptulvzPyQFm81dN3YXkT3JHK35NIgt3MW8dU0yBUoeFBoRVZX6TvTX7
xtEk2qitH7wNI+vkJKC+K9+vQXHMawvmS5JfN6hBXy3TJlaiy+evWxR4HS/E0vAM
1Q3fTqlZKuFLjqVs6e5VcNkNZxR+XxwCWdRUzQGjeBy4KyZE3nQkJx/efG/pIb+M
eKhTGjFr7sr15rfa/U5yJcTzvR0J+rZqg2WXnIFqYq8bab12NDFrFykbpLOqyyZV
Har+zdyoyWMlQE53Xdnt
=b9gJ
-----END PGP SIGNATURE-----

--qcHopEYAB45HaUaB--
