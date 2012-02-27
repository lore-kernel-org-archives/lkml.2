Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab2B0XlC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 18:41:02 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:40748 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752881Ab2B0XlA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 18:41:00 -0500
Date: Tue, 28 Feb 2012 10:40:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        "Hans J. Koch" <hjk@linutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>
Subject: Re: linux-next: Tree for Feb 27 (gpio-sodaville.c)
Message-Id: <20120228104047.85b5515f3b27c631580f5503@canb.auug.org.au>
In-Reply-To: <4F4BC3C5.8040802@xenotime.net>
References: <20120227182029.545a7db32550ce94c9faffb4@canb.auug.org.au>
	<4F4BC3C5.8040802@xenotime.net>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__28_Feb_2012_10_40_47_+1100_z+sVIqtrrUfFTSVJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__28_Feb_2012_10_40_47_+1100_z+sVIqtrrUfFTSVJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, 27 Feb 2012 09:56:21 -0800 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
>
> on i386:
>=20
> drivers/gpio/gpio-sodaville.c:130:2: error: unknown field 'dt_translate' =
specified in initializer
> drivers/gpio/gpio-sodaville.c:130:2: warning: initialization from incompa=
tible pointer type
> drivers/gpio/gpio-sodaville.c: In function 'sdv_register_irqsupport':
> drivers/gpio/gpio-sodaville.c:152:8: error: 'struct irq_domain' has no me=
mber named 'irq_base'
> drivers/gpio/gpio-sodaville.c:182:2: error: implicit declaration of funct=
ion 'irq_domain_add'
> drivers/gpio/gpio-sodaville.c: In function 'sdv_gpio_remove':
> drivers/gpio/gpio-sodaville.c:263:2: error: implicit declaration of funct=
ion 'irq_domain_del'

These are a conflicts between the gio tree and the irqdomain tree.
Grant, can you supply me with a merge fix patch?  Or will you merge the
irqdomain stuff into the gpio tree (making sure that the irqdomain tree
never rebases again) ...

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__28_Feb_2012_10_40_47_+1100_z+sVIqtrrUfFTSVJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTBR/AAoJEECxmPOUX5FEkgYQAKVNkbQTDzgM+8O6ES0JYDfG
TWwz0OBH+da2sLMDBltzjrgJ5FppLfEa0Frqt/gqJFJcX/OAyUciX7m0GtTcnzt3
D21WtLxNqO/ZYIIfR7m1rpo8mXSkEGWEUzPgzErMrJVO+IfBgq/6RZSBX30Lduy/
UGMLAS1Reu5/VEFglVvIr56oWKmte+6GKXhzfQVGXXtJL4PgG6vUZLYiWmLDt0p6
1fuzq2lSo+1t1xOJXkV4BVpAlaJRI+aVaaYNxviGOma2vJPW2Ano/Msi13KJmQhX
wJzsYWTjwaRoWI3UAC7T3Auf4f6tJOBgTRJqS6koJq8yJ9SxEw3W6xEkpYCIVLkJ
4/X/4eqPXUK/AQfZFKeDmK4zDF+5spJmt9NLPhmHJ9KH6OHopMEsg/lNdaOWSYmf
DhP6GyT1iGddK0+1ioqqAyTtySiqzGcKqfDqZc8vtVL96M0MNRRWfM/cuPbRpmnm
gH7eZ2/X8BUN/l+gYnSdskjB58QIX5QjGtT1i47cUuUroT3V8Rrc8y0wh4ccLQy+
NUeI2tz42Z9xK5kXXfJhlhtg9kTT1fz1I3L3xZSwbTLtYB8eIWjf3jjMDH4QCEm2
7gRJsYezRH1k9ZoGGNucRb6fcHmnxqR7a94tneZuWzD9Wn4UtX7W1wwmSD+crMor
JhE9yNr3aKxeRhYgwq0u
=GKcz
-----END PGP SIGNATURE-----

--Signature=_Tue__28_Feb_2012_10_40_47_+1100_z+sVIqtrrUfFTSVJ--
