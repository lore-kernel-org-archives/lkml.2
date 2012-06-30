Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754286Ab2F3LYU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jun 2012 07:24:20 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:63624 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753615Ab2F3LYT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jun 2012 07:24:19 -0400
Message-ID: <1341055455.2115.4.camel@koala>
Subject: Re: UBI fastmap updates
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Richard Weinberger <richard@nod.at>
Cc: linux-mtd@lists.infradead.org, nyoushchenko@mvista.com,
        artem.bityutskiy@linux.intel.com, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, shmulik.ladkani@gmail.com,
        tglx@linutronix.de, Marius.Mazarel@ugal.ro, tim.bird@am.sony.com
Date: Sat, 30 Jun 2012 14:24:15 +0300
In-Reply-To: <4FEEDAA4.30105@nod.at>
References: <1340982869-77042-1-git-send-email-richard@nod.at>
	 <1341052998.2115.3.camel@koala> <4FEEDAA4.30105@nod.at>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-HKLAUO7/oJ1H6MZ4yjFY"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HKLAUO7/oJ1H6MZ4yjFY
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2012-06-30 at 12:53 +0200, Richard Weinberger wrote:
> So basically you want me to get rid of any vmalloc()'ed buffer?
> That's not easy.

How big is the buffer. What is its maximum possible size?

--=20
Best Regards,
Artem Bityutskiy

--=-HKLAUO7/oJ1H6MZ4yjFY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJP7uHfAAoJECmIfjd9wqK0EAkQAKPiyG29WZQbYty8VDI94PS7
s+Ys//OUPmA9tSjg5lg6rQIfYuKGzUHiGwetXnKRc/fKoy2j3r1b+UAOalWJ6KSL
Ir93piIfrXWwaPb85xIOhPaLTwt3NBNcbVUpMO0Restk7MqBna58G8E6dh9h07lF
pwA3HuKYV+Dd8tqbYcn3UatpPZ1aASZQQH4+ShxLt1j/zuJej226TBf8HtKiz+b8
/Sq1kTx2VZsvVxIuBqLFELZ34rwqoKhoD8ugyGviA9BTwO4Wj5+mLmAa7Ys0gMw2
NXXuIaA6vH2RAZB200RHdqDgnQw/vYtiuYUqZESpzdWADXa2uKFFyZXEH4xbaLHF
XiP0VTtqlbZI/XnHBP3vmDQFmUrXIhnJogIJXZ/6CIMtdpX5QAhsb6iQVlkUbXu3
GhmxW9uHZ08K3L07Y9/0Zj9Ug6Peh7BY8H2gcj9e2++kvomAbBHhpv+MA7LW6V8Y
VoWvpIgzaXsrnQHgDgs/0XwGhThW4CjAUhXZF+3LAKoZtnvpjqDLhrlk/TNUd5Wu
/mbxSzFLcqfnjJo9TMA6bpkJMGRCYG2E/oXQRk5HThtWriZckWtFOWeJ9fImAcQq
+twRhKDJefzLc3qJ08kiSU76pa8WJsXRNRQAZfTdpy/uB6Ce1uNdMb9dhaq719v+
uocddw5SjqTeAwwb8OLi
=rstz
-----END PGP SIGNATURE-----

--=-HKLAUO7/oJ1H6MZ4yjFY--

