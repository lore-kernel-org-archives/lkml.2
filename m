Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446Ab2KTPtd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:49:33 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:42867 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751801Ab2KTPtc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:49:32 -0500
X-Sasl-enc: aoRPV/VoVuBNIETiwg8DT35sU25zTBSNhMQkXVcdzdFA 1353426571
Message-ID: <50ABA680.3090102@imap.cc>
Date: Tue, 20 Nov 2012 16:49:20 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: possible regression in kernel 3.6: system hangs during nightly
 tape backup
References: <50AACB7E.8060601@imap.cc>
In-Reply-To: <50AACB7E.8060601@imap.cc>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig20AF413AF2D150ED7B8F4AA8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig20AF413AF2D150ED7B8F4AA8
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 20.11.2012 01:14, /me wrote:
> For the 4th time now after switching to kernel 3.6, my system became
> unresponsive during the nightly Bacula backup run. It looks as if
> all disk accesses are suddenly blocked [...]
> It never happened with kernel
> 3.5. For comparison went back to kernel 3.5.7 for a week and it
> never happened during that time. Last night I booted 3.6.7 and the
> very next backup caused the hang again. [...]
> I have photos of the remaining dmesg output
> which I'll try to upload somewhere accessible tomorrow.

Screenshots are now up on
http://www.phoenixsoftware.de/~ts/kernel36hang/
along with the .config of the kernel running at the time.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)


--------------enig20AF413AF2D150ED7B8F4AA8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlCrpooACgkQMdB4Whm86/n1KACeNIATnrJKOnFp/1rzh9F+gHXa
3KoAoIJeHkTPjcjvDZp+VQnshca1A6/C
=f44O
-----END PGP SIGNATURE-----

--------------enig20AF413AF2D150ED7B8F4AA8--
