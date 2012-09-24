Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754224Ab2IXNFj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:05:39 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50015 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858Ab2IXNFi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:05:38 -0400
Message-ID: <50605A88.8060503@gmail.com>
Date: Mon, 24 Sep 2012 15:05:12 +0200
From: Andrzej Giniewicz <gginiu@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120910 Thunderbird/15.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Daniel Mack <zonque@gmail.com>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Sound got mute in kernel 3.5.4 (Fast Track Pro USB Sound Card),
 found commit that causes it - how to proceed?
References: <505B455D.2040603@gmail.com> <505D816B.4080902@gmail.com>
In-Reply-To: <505D816B.4080902@gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA94D8C1FBECC0864DF24E7A3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA94D8C1FBECC0864DF24E7A3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 22.09.2012 11:14, Andrzej Giniewicz wrote:
> On 20.09.2012 18:33, Andrzej Giniewicz wrote:
>> today I updated kernel to 3.5.4 and noticed, that all my sound from Fa=
st
>> Track Pro USB Sound Card got mute. I haven't noticed any error reports=

>> or messages, all seems to work, the card is just silent. I downgraded =
to
>> 3.5.3 and applied patched from usb sound module one by one and found
>> out, that 3.5.4 minus " ALSA: snd-usb: fix calls to next_packet_size "=

>> works fine:
>>
>> http://git.kernel.org/?p=3Dlinux/kernel/git/stable/linux-stable.git;a=3D=
commitdiff;h=3Dca150f7ade5973c3bce19261bca6174d5c3cc342
> On Arch Linux forums we got another report, that USB Sound Card got
> mute, and works again after removing that change, so there are least tw=
o
> affected devices now:
>
> ID 04d2:5051 Altec Lansing Technologies
> ID 0763:2012 Midiman M-Audio Fast Track Pro
Got report about third case of muted device, this time more popular one:

ID 041e:3040 Creative Technology, Ltd SoundBlaster Live! 24-bit External
SB0490

I don't know if those informations help at all, but this is best I can
do for now, because I have no idea what to look for. I have one of
affected devices and I have no troubles with patching/rebuilding module,
so I'd be happy to offer any help, just tell me what logs, device info
or debug outputs are needed and I will do my best to provide them.


--------------enigA94D8C1FBECC0864DF24E7A3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iQEcBAEBAgAGBQJQYFqWAAoJEED1V7cxSWEGcSsH/2y0RBFBAsBQ+/oLydacFplL
3KY+dQkIPdYYS8oM8tUcJitppol88m34UDUSB1eD50gKPPpt+kbYsTPQlQp0KjY/
iZcfbYbHROFE14mk9XJRLjvzcalfSJLisfMnMBlAxwYBuggS+EhndXc94mMylqTL
hC4ISCRXDwwCPVF8g82BP3Jnq1Tb1CRFSq6nmGpC10cnDDboBqUGScErlGk2+5cf
Kquwou7DNrJP4APM7DFXkeLrSV8lSCM1hZ/H9ou1PccUlWpKbCoa5ZVkouPqSzXZ
3FqSkaLuVd/4mavAPeRzAN+mQN6YCxHyZGJflBaz918F4q70XTm27/5wxqVdcR4=
=0IhW
-----END PGP SIGNATURE-----

--------------enigA94D8C1FBECC0864DF24E7A3--
