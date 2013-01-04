Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427Ab3ADLZS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 06:25:18 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:57715 "EHLO
	out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752650Ab3ADLZQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 06:25:16 -0500
X-Sasl-enc: odfoY5n3I0dGuEyvxAD7HX6QxqqdIZiWCCzu/5c/+7/1 1357298715
Message-ID: <50E6BC10.3040505@imap.cc>
Date: Fri, 04 Jan 2013 12:25:04 +0100
From: Tilman Schmidt <tilman@imap.cc>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression: Bacula jobs fail with kernel 3.8-rc1
References: <50E1AA27.5000508@imap.cc>
In-Reply-To: <50E1AA27.5000508@imap.cc>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigB80563E730C8DA85922E45AC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigB80563E730C8DA85922E45AC
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

On 31.12.2012 16:07, /me wrote:
> With kernel 3.8-rc1, my nightly Bacula backup job reproducibly aborts
> 20 minutes into spooling with a "broken pipe" error on the network
> socket connecting the file and storage daemons:
[...]
> Returning to kernel 3.7.1 makes it work again.

Update/correction: in the meantime

- I had some jobs succeed on kernel 3.8-rc1,
  so the failure is not fully reproducible

- it happened with kernel 3.7.1 too, though much less frequently

- I went back to 3.6.11 where I the failure hasn't occurred so far

BTW the fact that the job spends 20 minutes spooling appears to be
part of the problem; a job which aborted after 20 mins on 3.7.1
completed in 3 mins on 3.6.11.

--=20
Tilman Schmidt                    E-Mail: tilman@imap.cc
Bonn, Germany
Diese Nachricht besteht zu 100% aus wiederverwerteten Bits.
Unge=F6ffnet mindestens haltbar bis: (siehe R=FCckseite)



--------------enigB80563E730C8DA85922E45AC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAlDmvBkACgkQMdB4Whm86/l5ZACfQTZW35PcOf4Cn/GYQUkz1/v+
+ZMAn2w4q9VKxMSUnXFYW9kwa/8IiJaj
=S2CX
-----END PGP SIGNATURE-----

--------------enigB80563E730C8DA85922E45AC--
