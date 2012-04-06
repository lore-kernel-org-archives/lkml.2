Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757842Ab2DFT13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 15:27:29 -0400
Received: from mail.southpole.se ([193.12.106.18]:58257 "EHLO
	mail.southpole.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757792Ab2DFT12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 15:27:28 -0400
Message-ID: <1333740442.17877.9.camel@satguru>
Subject: Re: [PATCH 04/19 v2] openrisc/mm/fault.c: Port OOM changes to
 do_page_fault
From: Jonas Bonn <jonas@southpole.se>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux@openrisc.net,
        linux-kernel@vger.kernel.org, "Mohd. Faris" <mohdfarisq2010@gmail.com>
Date: Fri, 06 Apr 2012 21:27:22 +0200
In-Reply-To: <CAFPAmTTDjSPYA5bqK8-Xp50rcyB4fZRpGP-Q-JUzMgOZERHvEg@mail.gmail.com>
References: <1333195251-5046-1-git-send-email-consul.kautuk@gmail.com>
	 <1333730496.17877.7.camel@satguru>
	 <CAFPAmTTDjSPYA5bqK8-Xp50rcyB4fZRpGP-Q-JUzMgOZERHvEg@mail.gmail.com>
Organization: South Pole Consulting AB
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-l4u3tQ2/nOyzecpEOQK5"
X-Mailer: Evolution 3.2.3-0ubuntu5 
Mime-Version: 1.0
X-Assp-Version: 2.1.1(11364) on assp.southpole.se
X-Assp-Client-SSL: yes
X-Assp-ID: assp.southpole.se 40445-07618
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



--=-l4u3tQ2/nOyzecpEOQK5
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-04-07 at 00:53 +0530, Kautuk Consul wrote:
> Thanks for the ACK !
> Since I don't have any branch of my own, can you please apply this to
> your branch ?
> Or else, I'll have to ask someone else to apply this on their branches
> and thats a relatively longer process. :-(
>=20

Sure, no problem, I'll take this via the openrisc tree.  Thanks for the
detailed explanation.

/Jonas

--=-l4u3tQ2/nOyzecpEOQK5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk9/Q5oACgkQ70gcjN2673OEwwCfZnUz3geNDMN0JZ4XRhF6zb6D
izsAniv3yx9favoYo0R1TfjltvEqiLbX
=McQ/
-----END PGP SIGNATURE-----

--=-l4u3tQ2/nOyzecpEOQK5--

