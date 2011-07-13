Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754226Ab1GMNpg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 09:45:36 -0400
Received: from daemonizer.de ([178.77.99.65]:43181 "EHLO daemonizer.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545Ab1GMNpe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 09:45:34 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Jul 2011 09:45:34 EDT
From: Maximilian Engelhardt <maxi@daemonizer.de>
To: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: Kernel crash after using new Intel NIC (igb)
Date: Wed, 13 Jul 2011 15:38:21 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.39-2-amd64; KDE/4.6.4; x86_64; ; )
Cc: Arun Sharma <asharma@fb.com>, David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Yann Dupont <Yann.Dupont@univ-nantes.fr>,
        Denys Fedoryshchenko <denys@visp.net.lb>
References: <201104250033.03401.maxi@daemonizer.de> <4DDEEBC5.80804@fb.com> <1306466831.2543.58.camel@edumazet-laptop>
In-Reply-To: <1306466831.2543.58.camel@edumazet-laptop>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart93616860.MMjp0fhceP";
  protocol="application/pgp-signature";
  micalg=pgp-sha512
Content-Transfer-Encoding: 7bit
Message-Id: <201107131538.26960.maxi@daemonizer.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart93616860.MMjp0fhceP
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 27 May 2011 05:27:11 Eric Dumazet wrote:
> Le jeudi 26 mai 2011 =C3=A0 17:09 -0700, Arun Sharma a =C3=A9crit :
> > On 5/26/11 3:01 PM, Eric Dumazet wrote:
> > >> Yeah - using the refcnt seems better than list_empty(), but I'm not
> > >> sure that your patch addresses the race above.
> > >=20
> > > It does.
> >=20
> > True. I can't find any holes in this method and it resolves the "failure
> > to unlink from unused" case.
> >=20
> > Perhaps wrap the while(1) loop into its own primitive in atomic.h or use
> > an existing primitive?
>=20
> Sure, here is a formal submission I cooked.
>=20
> Thanks

Thank you for your patch. We have it running now for some time and didn't=20
observe any crashes.

I have one question left. We want to install the same card in another serve=
r=20
that is currently running Debian stable with a 2.6.32 kernel. Is this bug a=
lso=20
present in that version or has it been introduces afterwards? This server i=
s=20
used by many people for Internet access, so it would be quite bad if it=20
crashes.


Thanks again for your work on the patch.

Greetings,
Maxi

--nextPart93616860.MMjp0fhceP
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCgAGBQJOHZ/OAAoJEIHqZH0kK9IVUL8P/jIJxKnJSA36CqD+iXVGChoo
nSeIrq64e5NGta8IUWEPalHTh1GTNGirvAJvvVQNg83g6qfxoDb9LAsjELndzLty
fzqnN9GgdcrznFRjHZ2jmuMZHysVwSmqC/Sgn9Rd++6cyIwV6qy1EICSAD8JmSw3
7DJQMNd13y4MBpx/OswAKyJyR3xnebEb8gEGpY2ooRi/2VcLf76qkCtPEHncHlk3
wJlW8eDuNIg9NCxrAVaWscjbTvrg57x+l0PpBOtZneJmj0lQ77gCKACjE4dSDWun
aVuIrtyXxxZZRjh0TO3uD1NzVuFYDbHn2Qb46O085lMkdIQzRwDLbJKa/qwQR+p7
AJ7hc019ggJ3ZteaFIa1MDbOmQqHG2uew1MpQKziImA1bzZavej7WdGxyqKDrQvM
Af90QzmONNojaT6Sa69joUiPASOxwArdt9aGF6oRh1yHZsC7Seyy2qBuJUKdIX0M
ip1ysR/IIgWXBhl+2uFHU015AwGA4iUw65sjOjqG3JWMbMU/Nom2NzZB0OP/hRUo
jIyiCb2b0apFBpOfk0sSnCsqBLHpwuwQiE/rn/936d/aH/bY7mI+rtOTEUIJny+Z
AGDpoI/LY/hLfkkdeGvtugPZvQj8U0Azgq5YQ99X4lGyYnHKsROPnNzzuGV+WMED
p/lrReMaaN6NPwzogAC4
=D31C
-----END PGP SIGNATURE-----

--nextPart93616860.MMjp0fhceP--
