Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752366Ab2F2G6k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 02:58:40 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:48008 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751162Ab2F2G6j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 02:58:39 -0400
Date: Fri, 29 Jun 2012 16:58:36 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: linux-next: manual merge of the pwm tree with the s5p tree
Message-Id: <20120629165836.95668052d64550c609453857@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__29_Jun_2012_16_58_36_+1000_s02vwDUjTfVNLVvQ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jun_2012_16_58_36_+1000_s02vwDUjTfVNLVvQ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thierry,

Today's linux-next merge of the pwm tree got a conflict in
drivers/pwm/pwm-samsung.c between commit 8f748e20b806 ("ARM: SAMSUNG:
Remove unused variable 'running' on PWM") from the s5p tree (where it is
called arch/arm/plat-samsung/pwm.c) and commit 2663e766c56a ("ARM
Samsung: Move s3c pwm driver to pwm framework") from the pwm tree.

I fixed it up and can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__29_Jun_2012_16_58_36_+1000_s02vwDUjTfVNLVvQ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP7VIcAAoJEECxmPOUX5FEDWoP/jfnhxE3dBTjt4MwyPvUlhsp
SR0swOYBcRwvISmfJh/5TKk9AEcoT/1lzgN3Nq6G1McdV3ySPYKeBH+93yqUJzRR
jAndx375c6pShwMOtU+Q3Q6pCsPtczB0O3WIekOWLLPjSCjuqyyv4vCKroNndBrg
8Lfjagdok7QBhIpKEiV6vBcEnfwWvI8VIWViGZ1e41DC3DtlLClPsPhdm5gq0JNJ
4PYJwba6HM+m2GqFtJGhlFUJLj9vdciGQhMj8qLlwKUrSxcMyYfCtfNX6JP0TSi1
bYiBazJJqK9PLMOe6opEA8hEKg1L1yYfTG6eCyMwKhCRNAYhWIYpgqLa4UVgEiLG
9MZhBJ1xMlIENrgtDn4OOo4v3jrOvm52wHSs3wdNUSBiccSYjzInv7oQIAJxuHO2
7+JTpHasQ9eN4cGudLPmv8EpBIR0KS8QgRW4kOXuP1KzyEAeJz3rpydjbfxtIl/T
FQDgdVthnR7jhQPnwbuVLk4iDY891E7dixI/hk+s+dsdQSNiz3AnGwBH1XkK73gt
TvGcxzY6WRX8CSVitAyzIRKp8wPhNlpYTSdekgCV/MUQQkRTOnEouyf5+Xl8q8VQ
aNEgmhLcrouYhH3uOjsnFV7KV+iJ4NPBcGaJfvv1AkVKONktIVz7qEQ2UwMAO7vY
igZ/E8VR9HvSi/V55rHj
=btHg
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jun_2012_16_58_36_+1000_s02vwDUjTfVNLVvQ--
