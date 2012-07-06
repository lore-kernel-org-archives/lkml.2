Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab2GFGPG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:15:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33888 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2GFGPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:15:05 -0400
Date: Fri, 6 Jul 2012 16:14:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Subject: linux-next: build failure after merge of the gpio-lw tree
Message-Id: <20120706161455.dd899154fbc8a79ee530572f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__6_Jul_2012_16_14_55_+1000_i2dOr8aAyNblvVbz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__6_Jul_2012_16_14_55_+1000_i2dOr8aAyNblvVbz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Linus,

After merging the gpio-lw tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "irq_set_chip_and_handler_name" [drivers/gpio/gpio-pcf857x.ko] undef=
ined!
ERROR: "dummy_irq_chip" [drivers/gpio/gpio-pcf857x.ko] undefined!

I have dropped the gpio-lw tree for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__6_Jul_2012_16_14_55_+1000_i2dOr8aAyNblvVbz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP9oJfAAoJEECxmPOUX5FEvw4QAIYkoY3F4syp4XOEly1L8vEg
DVByABKR0UjlRi0svGM5DNMEenbRQoH3JmNlsl1l74D+YlDf2DKJGuhneBlsyirm
0OOxig5gYtRnShZ6HAb7aOxmjmirnbf/u5YOJisYKN9qeMSe8wEkb85kOQjaxpQV
Rx0Z0fpkfywvs7BJi4D0G/NBMmPcxVEPdHwCK7GdHoBwZM6I7MQVisqSNA3gWBC8
MGMuahoTCOTpmnfGKTyzrNke7I1A147KzPW0aiF4GMYozBsAzpjWsGcAnTOgWNwI
cGf4UmSjwvhKyAa1IMSu3ZiR3PwsL8+NYBPdzuDn0oHqxBsiwviCeWtwogMI9ehL
jgqZJysujzlMigzw3cSbXJxzYkTlHG6dy8njHI421aqWRUt1oPUW4Qoek2SkzTHr
mubS0F7ObnolFPSTa498rau1BlP8UNR6uGe+2tgYInwfDb3YxDuq0CnSopBcPkfi
DdpgQQjiFU0M2jPPXsEW4wTZuZJB3TLeTqf+WMMk9ADqKj+n+4YhiWtWSA5yMTt+
2uZrVet2o6cPr9WxqInpkDs6cSMdkoUo8VTOaCkOZWE0OusLehRYkAq1dtTjmYtd
vYuJzeF6UD033zsgC8RPD+lWupAYfSJgLMD6A6M0HlKJNSoqezsE41EVkIx3OR9T
sr6OHCm1OpAvz+4PQu67
=lf11
-----END PGP SIGNATURE-----

--Signature=_Fri__6_Jul_2012_16_14_55_+1000_i2dOr8aAyNblvVbz--
