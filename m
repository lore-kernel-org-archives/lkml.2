Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935887Ab2JYTpa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 15:45:30 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45997 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934077Ab2JYTp3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 15:45:29 -0400
Date: Thu, 25 Oct 2012 20:45:25 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Andrey Smirnov <andrey.smirnov@convergeddevices.net>
Cc: hverkuil@xs4all.nl, mchehab@redhat.com, sameo@linux.intel.com,
        perex@perex.cz, tiwai@suse.de, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/6] Add the main bulk of core driver for SI476x code
Message-ID: <20121025194524.GV18814@opensource.wolfsonmicro.com>
References: <1351017872-32488-1-git-send-email-andrey.smirnov@convergeddevices.net>
 <1351017872-32488-3-git-send-email-andrey.smirnov@convergeddevices.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="buDNgeHiu+HCsDEc"
Content-Disposition: inline
In-Reply-To: <1351017872-32488-3-git-send-email-andrey.smirnov@convergeddevices.net>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--buDNgeHiu+HCsDEc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 23, 2012 at 11:44:28AM -0700, Andrey Smirnov wrote:

> +	core->regmap = devm_regmap_init_si476x(core);
> +	if (IS_ERR(core->regmap)) {

This really makes little sense to me, why are you doing this?  Does the
device *really* layer a byte stream on top of I2C for sending messages
that look like marshalled register reads and writes?

--buDNgeHiu+HCsDEc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiZbLAAoJELSic+t+oim9LPsP/0Vm/MQazZiGXS+B/pNjIHFy
iHEBnSuX5Kt8PHQzxd/OqgZ9olHw7QNYsbv7wItWJgJXxESFMZaQTPgsKB+8MXLy
6xO/YmHDvPK0OACJWhFom78vYAYaNf8OcejXn6k8v6JyI5vJqJOlS207tqu/Ce+w
yGokL33lHxvU+2C8DLMYmQOTEknDr1FwlhvteBFvLSaU0IDEq0hPWSoEVtqpaAy1
4GkRNbdmM7DqrI69LQJACAD5Vrw5RcKv0skzBWtaxcANAVYOZkE/2PpxsxcacZPw
jNsjhp0lN0KNWtNDwQ7HGkxD53UmS+mlZbnS+RP4ikfc2R8ME0s5xapXYQ3mlPId
l8Qmo+TFUYALvFXOlzA4HKagPzHEKvSUqXxiPVGqgtvWt6r5cgddRJqvzZkeEQwk
eIGMhaYJubqvAO8PNIYPA4cK5rh4YS7NwCLkBLd8XH2H0BSsAXXaT4PZGUb3FJEm
s+o/x7F1+CFTyVl5rsJu+MTKubG7UxkdTgwMsYJfNusw8h65SKq1I/S9zsuWIt6X
08/AnPnwF1cF1ZDzIURDV0PpqDc80nqPFFE7WICb/3+DesA3Fw5KaetOWA49LNUv
6kS52H9YFVG9w0nbVSdgcHAp4UdEAwwjeM8Q461JfOKOUuRjo9zatIOOuuWchMQ4
7lx/s2sV/qsIYOoCS7Ex
=uXIx
-----END PGP SIGNATURE-----

--buDNgeHiu+HCsDEc--
