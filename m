Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab0CXWeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 18:34:20 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33095 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751679Ab0CXWeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 18:34:19 -0400
X-Sasl-enc: w0QY2R/37J+Hbij7/tAQrOkpDw+jSPhvXnC3hfzLMqgU 1269470058
Message-ID: <4BAA92B3.5060808@imap.cc>
Date: Wed, 24 Mar 2010 23:31:15 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, apw@canonical.com
Subject: Re: [PATCH] checkpatch: Add check for too short Kconfig descriptions
References: <20100320023216.GA917@basil.fritz.box> <4BA4CE32.1020207@imap.cc> <20100320140710.GS20695@one.firstfloor.org> <4BA504DD.2060107@imap.cc> <20100320180336.GT20695@one.firstfloor.org> <4BAA0598.9000906@imap.cc> <20100324133939.GF20695@one.firstfloor.org>
In-Reply-To: <20100324133939.GF20695@one.firstfloor.org>
X-Enigmail-Version: 1.0.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDB5A480DC862D962F5DC23AA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDB5A480DC862D962F5DC23AA
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 24.03.2010 14:39 schrieb Andi Kleen:
>> - -+			WARN("please write a paragraph that describes the config symbol=
 fully\n" . $herecurr) if ($length < 4);
>> ++			WARN("Less than four lines of help text -- consider adding more d=
etail\n" . $herecurr) if ($length < 4);
>=20
> I don't want to give the number, because that just tempts people
> to "game" the rule. Ideally they should just use as many lines
> as needed, not just four.

You're working against people instead of with them.
IMHO that is never a good idea.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enigDB5A480DC862D962F5DC23AA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)
Comment: Using GnuPG with SUSE - http://enigmail.mozdev.org/

iEYEARECAAYFAkuqkr4ACgkQQ3+did9BuFsj1QCfaRLobhkmAy5kPMhwIOQhj+kM
4EQAnRJeex+AUdg/Qxr0t7MiF84IPRO6
=PS1C
-----END PGP SIGNATURE-----

--------------enigDB5A480DC862D962F5DC23AA--
