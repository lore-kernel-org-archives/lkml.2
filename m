Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755796Ab2B2IjY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 03:39:24 -0500
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755395Ab2B2IjW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 03:39:22 -0500
Message-ID: <4F4DE438.6050707@nod.at>
Date: Wed, 29 Feb 2012 09:39:20 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Jonas Bonn <jonas@southpole.se>
CC: arnd@arndb.de, linux@openrisc.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] OpenRISC: IRQ: Include module.h
References: <1330476393-14264-1-git-send-email-richard@nod.at>  <1330476393-14264-2-git-send-email-richard@nod.at> <1330501749.2964.4.camel@crucifix>
In-Reply-To: <1330501749.2964.4.camel@crucifix>
X-Enigmail-Version: 1.3.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigF8313FE77F2A93B7EDFF58C5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigF8313FE77F2A93B7EDFF58C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 29.02.2012 08:49, schrieb Jonas Bonn:
You are right. export.h is better.
I forgot commit f501693 (module.h: split out the EXPORT_SYMBOL into expor=
t.h).

> Thanks for helping out with build-testing the OpenRISC arch... much
> appreciated.

I'm doing more than build-testing.
Yesterday my FPGA board booted the very first time Linux on OpenRISC. :-)=


Thanks,
//richard


--------------enigF8313FE77F2A93B7EDFF58C5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPTeQ5AAoJEN9758yqZn9ewlAIALTvuQI8KEBOlfYCWUWJQqYW
mKyPFAozH5s/EoaupcMLwIjlmU1BzgWp1bGDNinw2ozOzzSuexl1abLvHqGLo45H
BgEwSiRU/heqC4OrTY1R09eUsW7rt7KSZyBZUGT6SFbzkkcRml05g73FcTDn6/Hq
vqrKBysqv7CYcsZ9nkDu3liOp0qqardRTLOLj6HwWu5xIj3G+VQvE6m66I/hWYqh
3DC824K3JYzKcukBEWSY/lZwfksssGlIPKg7eodskQmLjpG/tDYyJQlO9+lcMvHp
MLtUKD52unzkhd8MNnB/Pzz56F3CtijiyOf1FnTBzXeCNQlDd0+WqgPfVQQtls8=
=XGYD
-----END PGP SIGNATURE-----

--------------enigF8313FE77F2A93B7EDFF58C5--
