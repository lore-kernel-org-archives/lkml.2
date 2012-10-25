Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759982Ab2JYQQY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:16:24 -0400
Received: from mail.southpole.se ([193.12.106.18]:51709 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab2JYQQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:16:21 -0400
Message-ID: <1351181778.6232.71.camel@jerome.southpole.se>
Subject: Re: [PATCH 1/2] openrisc: move sys_clone's stack determination to
 copy_thread
From: Jonas Bonn <jonas@southpole.se>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Date: Thu, 25 Oct 2012 18:16:18 +0200
In-Reply-To: <20121025155516.GL2616@ZenIV.linux.org.uk>
References: <1351179999-8376-1-git-send-email-jonas@southpole.se>
	 <1351179999-8376-2-git-send-email-jonas@southpole.se>
	 <20121025155516.GL2616@ZenIV.linux.org.uk>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-3MQ9IX334AcX5kyd5rbZ"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Mime-Version: 1.0
X-Assp-Version: 2.2.1(12265) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-Server-TLS: yes
X-Assp-ID: assp.southpole.se 81779-03494
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-3MQ9IX334AcX5kyd5rbZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-10-25 at 16:55 +0100, Al Viro wrote:
> On Thu, Oct 25, 2012 at 05:46:38PM +0200, Jonas Bonn wrote:
> > +		else
> > +			userregs->sp =3D regs->sp;	/* fork/clone */
>=20
> What for?  userregs->sp will be equal to regs->sp at that point, unless
> your compiler is very badly broken.  You've copied *regs to *userregs
> wholesale, just above that if...

So true... that makes it even simpler.  Will resend.
/Jonas

--=-3MQ9IX334AcX5kyd5rbZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAlCJZdIACgkQ70gcjN2673OC6gCg0THkX8ziDmRhFdVFr4uoe8k0
azoAn2bDbS/agCMw+R0ImgjrTtqLmqsl
=VfOF
-----END PGP SIGNATURE-----

--=-3MQ9IX334AcX5kyd5rbZ--

