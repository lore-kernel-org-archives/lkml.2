Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab0JKRFq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 13:05:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51403 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755678Ab0JKRFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 13:05:44 -0400
Message-ID: <4CB343DC.3050506@corscience.de>
Date: Mon, 11 Oct 2010 19:05:32 +0200
From: Bernhard Walle <walle@corscience.de>
Organization: Corscience GmbH & Co. KG
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100922 Thunderbird/3.1.4
MIME-Version: 1.0
To: David Daney <ddaney@caviumnetworks.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: octeon: Add Lanai board USB clock type
References: <1286791747-3151-1-git-send-email-walle@corscience.de> <4CB340F1.8020000@caviumnetworks.com>
In-Reply-To: <4CB340F1.8020000@caviumnetworks.com>
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig25220E0433DD9F6709EEA0D2"
X-Provags-ID: V02:K0:fllqhh7c0qoOmedRa3w++BL/MCamNhCa8kAlFxoWYbb
 s6PBUs5UhXdnuw+2Mi9b4ap2E7P7BrnztqqqNNlnLRsEEF0xqb
 Ex2wlocH/GnGugWgecCMmTrx+T2awbiLMAXzUHAHXPJf5nuUhB
 fMUmbq6pKRw2dCM7Z4Qfrtxk/0wiJpuiP+UW0cjIIw4OhgL1d3
 EmsTXFzkxSuTIMdkN9wyg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig25220E0433DD9F6709EEA0D2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 11.10.2010 18:53, schrieb David Daney:
> On 10/11/2010 03:09 AM, Bernhard Walle wrote:
>> Add the LANAI2 board to __cvmx_helper_board_usb_get_clock_type(). It
>> also uses the USB_CLOCK_TYPE_CRYSTAL_12 clock.
>>
>> Signed-off-by: Bernhard Walle<walle@corscience.de>
>> ---
>>   drivers/staging/octeon/cvmx-helper-board.c |    1 +
>>   1 files changed, 1 insertions(+), 0 deletions(-)
>=20
> NAK.
>=20
> We don't currently support USB, so churning up this file doesn't help=20
> anything.

Well, agreed, but why not removing that code entirely then?


Regards,
Bernhard


--------------enig25220E0433DD9F6709EEA0D2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQIcBAEBAgAGBQJMs0PcAAoJEIQVJz6X/I4DGpMQAI7J4i8RLyuc4E3UeE2KmUxW
MvEDb5MLJslGMW13Q1MVOugaTjNkp54oFdFyyGoxlZxgojl+D2CezggnZCAc0Enl
0fLcK1EyjKZYQ5S/R3nM1GOTCVA8IbTig/UiVCDMAkVxGU7YFPS5AGuy2Wi5m+nB
kdP0nRpKu3iPU6oItH0VhoXNY9Kyn+Y+c8Ei3RhWYxolv4KaDgdRedgeP+hw8/q2
z94I1WhwAqOGX1eAI3ehZekffllxmHe57zs6XC9a7h6mYgamPFa5BzLnku5nugGs
f9BYQIdi47W9SuQ8JIMZdHzcdMztMhVgYuXmEI2QujTHNZWeOuiEs6Fs1xdLKO5m
xcdHT4vk/WbKifItEnGPE2qr3EfWlkfqajwfIxEhVGA85+0axrsZHBtIAGdRm5gD
35eXgC/Wsf+c3mosFMsOP6ws/WTGlP2HBIy3xQpQ5DfZcRX/imgiwxUFQnin9BEX
9Z7tnqZISmCuEqZJ9FxATcnImOeHIaArIcTfRrtjMnoCy/zmeTfbRdpKqIm7303u
HDjQPJEc7xh/E5raqX+Yt0nlYBPgDulIWTrUJFv1mJA5A/Q8LwjtjIxBpngO30I5
1rYaT8nsKV5Gp/RCtES5v6QvI8pUpcfAv7QwoxI5fJ15Tfc9EqGoMLKyXGTl4U0w
4Z8aNhhlvthieR2d7HDL
=nbGJ
-----END PGP SIGNATURE-----

--------------enig25220E0433DD9F6709EEA0D2--
