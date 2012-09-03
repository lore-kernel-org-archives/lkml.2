Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756519Ab2ICQi1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 12:38:27 -0400
Received: from ngcobalt07.manitu.net ([217.11.48.107]:41748 "EHLO
	ngcobalt07.manitu.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab2ICQi0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 12:38:26 -0400
X-Greylist: delayed 2651 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Sep 2012 12:38:25 EDT
X-manitu-Original-Sender-IP: 127.0.0.1
X-manitu-Original-Receiver-Name: ngcobalt07.manitu.net
Date: Mon, 3 Sep 2012 17:54:02 +0200
From: Roland Eggner <edvx1@systemanalysen.net>
To: Alexander <alexander@dce.bg>
Cc: Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: missing dependencies in drivers/usb/mon/Kconfig (was: file
 Documentation/usb/usbmon.txt should list the .config settings)
Message-ID: <20120903155402.GA10830@mobil.systemanalysen.net>
Reply-To: Roland Eggner <edvx1@systemanalysen.net>
Mail-Followup-To: Alexander <alexander@dce.bg>,
	Oliver Neukum <oneukum@suse.de>, linux-kernel@vger.kernel.org
References: <50446CA1.7040904@dce.bg>
 <4905024.kP3GZmCRKy@linux-lqwf.site>
 <5044C36B.2010300@dce.bg>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Content-Disposition: inline
In-Reply-To: <5044C36B.2010300@dce.bg>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 2012-09-03 Monday at 17:49 +0300 Alexander wrote:
> On 09/03/2012 12:23 PM, Oliver Neukum wrote:
> > On Monday 03 September 2012 11:38:57 Alexander wrote:
> >> Please indicate in the Documentation/usb/usbmon.txt file that the kern=
el
> >> needs to be compiled with:
> >>
> >> CONFIG_DEBUG_KERNEL=3Dy
> >> CONFIG_DEBUG_FS=3Dy
> >> CONFIG_USB_MON=3Dy
> >> CONFIG_USB_DEVICEFS=3Dy
> > Are you saying tht the modular options have been broken?
> >
> > 	Regards
> > 		Oliver
> >
> >
> Ok what I meant is "if you want to build usbmon support into the kernel=
=20
> then it needs to be compiled with ..."
> I think it will be useful, especially for embedded developers to have=20
> this info in the usbmon doc file.
> Sorry about this confusion...

+1
Even more useful would be, if Kconfig would automatically take care of this=
 dependency.

--=20
Roland Eggner

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAlBE0pkACgkQdN/hKfT7G/L59wCeKin5WZ5WyBHe5h3XmMPiDOx1
eNsAnipbEwyy5fbEULy2AR95e9CSz0th
=wEdU
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
