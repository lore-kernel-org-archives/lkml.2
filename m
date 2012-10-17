Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756948Ab2JQN1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:27:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41700 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755666Ab2JQN1s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:27:48 -0400
Date: Wed, 17 Oct 2012 22:27:41 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arnd@arndb.de, linus.walleij@stericsson.com
Subject: Re: [PATCH 1/1] Documentation: Describe Device Tree bindings for
 GPIO Regulator driver
Message-ID: <20121017132740.GS14199@opensource.wolfsonmicro.com>
References: <1350374553-12678-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fLj60tP2PZ34xyqD"
Content-Disposition: inline
In-Reply-To: <1350374553-12678-1-git-send-email-lee.jones@linaro.org>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fLj60tP2PZ34xyqD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 16, 2012 at 09:02:33AM +0100, Lee Jones wrote:
> Here we specify all non-standard bindings which can be used when
> requesting the use of an GPIO controlled regulator from Device Tree.

Applied both patches squashed together, thanks.  Please don't split
documentation from the code like this where the code is just a single
change - it's sensible where the code is a big series but for single
patch it's not helpful.

Given the subject line I'd be extremely likely to delete this patch
unread, Documentation: says "this isn't relevant".

--fLj60tP2PZ34xyqD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQfrI2AAoJELSic+t+oim98LkP/3Q7R15BwAaUnHrXFZAPCiZ/
3qwYqw73weKnEbZjWarKtva1VuDHKZh0LAyVwFH3Fk85PM8xOF2r5kiOv108B07I
VZH07VBPGNfCv1TMkaDbB5hg/jtMt24bHK/Q0FhdjHLIfWFjYYCeyYvzDm5h6H6H
i+UPyjLrECmtN2aDlmE/uTjcMdc1juhYSddTquT8bIxF7AvIV+lGGKujJUNsiclI
/i40oxIO0jY8laB1O+64VRMaYe/jd7MrAVJJjqomJM6klUjxJhak8Crk/1U7d0oo
74bvkbt750Z5anl3K8/1gavlmpam2Rx/12xZkvWD2xvOYFvt8BqZ1Np9rg2H1RqC
Gdlt6RSaoNh200+XrUwSyjUshTrg/5ZTXWgpcV5KpBQsm5n22IRi4KolrGYDWxl2
7/h8RNM6xIw0xxBqy6sMT5YicR2Ki1mMSxVjh84VwT1Sx/zG72rmdBWllTlHr1bJ
wdJBQj9bw/8kmUtIMzUY9ooLyDZC8Q+BlqeUkvE/Rdunq5YI3bqapWqmDkOtw7SW
cR8Ew9wTa+Y9uLE06ZXs/MGP0dNHeC68R5z8VOge7KIK5kn5pyAB9Mtj69DFggtW
5bryyW6TJnOM3ZE6hG0CbiMMVLZzQPhULFv/4XVMVQdN7HzE/f25MSGaEezDwpq/
krnT4COKmSlZ03djrIwc
=D5PK
-----END PGP SIGNATURE-----

--fLj60tP2PZ34xyqD--
