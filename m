Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754813Ab2GAJln (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Jul 2012 05:41:43 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754400Ab2GAJll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Jul 2012 05:41:41 -0400
Message-ID: <4FF01B47.4060604@nod.at>
Date: Sun, 01 Jul 2012 11:41:27 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rusty Russell <rusty@ozlabs.org>
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, shmulik.ladkani@gmail.com,
        tglx@linutronix.de, tim.bird@am.sony.com, Marius.Mazarel@ugal.ro,
        artem.bityutskiy@linux.intel.com, nyoushchenko@mvista.com
Subject: Re: [PATCH 11/11] UBI: Fastmap: Add a module parameter to enable
 fastmap
References: <1340982869-77042-1-git-send-email-richard@nod.at> <1340982869-77042-12-git-send-email-richard@nod.at> <87vci8xaf7.fsf@rustcorp.com.au>
In-Reply-To: <87vci8xaf7.fsf@rustcorp.com.au>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE2A6B4FFFCB11DE28BBB6A92"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE2A6B4FFFCB11DE28BBB6A92
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 01.07.2012 08:28, schrieb Rusty Russell:
> On Fri, 29 Jun 2012 17:14:29 +0200, Richard Weinberger <richard@nod.at>=
 wrote:
>> The new parameter, ubi.fm_auto is per default 0.
>=20
> ...
>> +module_param(fm_auto, bool, 000);
>=20
> Hmm, do you really not want to see this in sysfs?  Or set it?

Okay, exposing this parameter to sysfs does not hurt and may be useful.
I'll change the permission to 0600.

Thanks,
//richard


--------------enigE2A6B4FFFCB11DE28BBB6A92
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJP8BtNAAoJEN9758yqZn9eOwoIAKuuk2aR9rXPCoxlan38jlhN
pfMxF8eDcrA9mVYkbbeKUrBs8MoAcrWkSpMfCfJ597l/isaz0CTrNeGHaXdlbznp
KPsBOk4nE0MXBCEXYcAQo1H9Xj2ArgSenspOMjzvmw3jMSPy8mOHbLuL7nMK0vOD
up6TqjEV9cW6GCSvuLBM2a7JvV5CrNyvRnsnKVfkfZNWjvhWsOuEJiuAE7hQBk3t
pM3knfDvP/tttW+wlTmC6VjnxdZo3KJAZNnHYPbvAvWWurTOWaeN3afb9gECK8vK
wartzzEKRsuw1ScVJtoKAiYCOlJ3p4QFcKIWwVykN/AyouRKUs3EHE5MVQcJX+E=
=/dR4
-----END PGP SIGNATURE-----

--------------enigE2A6B4FFFCB11DE28BBB6A92--
