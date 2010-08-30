Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753649Ab0H3H24 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 03:28:56 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42653 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab0H3H2x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 03:28:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=juVBvdhm0vG1fyaOXl3no2yRNSH+d8MK3rjC2kd8PeHtR2Be730qCZYBnmqoVy5qHT
         K9bE4nSkdyUnPZN3zbPWUom5CEglveQRklww32HX3vXBYruXO0vJ3VVYH6XRRrvItkzV
         p7KcfoUc94dYbT11CyDqstPXsMf5Z2jvpp9l8=
Date: Mon, 30 Aug 2010 10:29:00 +0300
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Len Brown <lenb@kernel.org>, Lin Ming <ming.m.lin@intel.com>,
        Jiri Slaby <jslaby@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-pm@lists.linux-foundation.org,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: BUG: scheduling while atomic
Message-ID: <20100830072900.GA11606@swordfish.minsk.epam.com>
References: <20100827075911.GA5966@swordfish.minsk.epam.com>
 <201008272102.52041.rjw@sisk.pl>
 <20100828064254.GA2128@elf.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LQksG6bCIzRHxTLp"
Content-Disposition: inline
In-Reply-To: <20100828064254.GA2128@elf.ucw.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On (08/28/10 08:42), Pavel Machek wrote:
> On Fri 2010-08-27 21:02:51, Rafael J. Wysocki wrote:
> > On Friday, August 27, 2010, Sergey Senozhatsky wrote:
> > > Hello,
> > >=20
> > > .36-rc2-git4
> >=20
> > Well, that looks like an ACPI battery driver issue.
> >=20
> > What was the last know good kernel?
>=20
> Also you might want to see if unloading battery driver before hibernation
> allows you do proceed...
> 									Pavel

Hello,
Sorry for the delay.
Last known good was .36-rc2-git3 (if I'm not mistaken).

Sure, will try with unloaded battery driver.


	Sergey=20


> --=20
> (english) http://www.livejournal.com/~pavelmachek
> (cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/b=
log.html
>=20

--LQksG6bCIzRHxTLp
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iJwEAQECAAYFAkx7XbwACgkQfKHnntdSXjTV0wQAtFwpJzjTWJd5pau5rVajcccJ
rAvd1kjSLcAM1M62CrMb3Ty3emZBx606wH7OmCUO6QoSx2slbfZrxqb5lBRD6Ko4
+PTPxxuL5qG0Vy1B//mZs/hxavIAQLkv0hEs1WQRE74SIOe0muLBSOYf43oqlkXS
EQvI0Ots0zWsCy+4EbQ=
=B42C
-----END PGP SIGNATURE-----

--LQksG6bCIzRHxTLp--
