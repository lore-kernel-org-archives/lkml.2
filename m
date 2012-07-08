Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237Ab2GHPL6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 11:11:58 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751859Ab2GHPL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 11:11:57 -0400
Message-ID: <4FF9A337.2010006@nod.at>
Date: Sun, 08 Jul 2012 17:11:51 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: Shmulik Ladkani <shmulik.ladkani@gmail.com>
CC: linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com, Heinz.Egger@linutronix.de,
        thomas.wucher@linutronix.de, tglx@linutronix.de, tim.bird@am.sony.com,
        Marius.Mazarel@ugal.ro, artem.bityutskiy@linux.intel.com,
        nyoushchenko@mvista.com
Subject: Re: UBI fastmap updates
References: <1340982869-77042-1-git-send-email-richard@nod.at> <20120708144745.36109029@pixies.home.jungo.com> <4FF9780D.4010709@nod.at>
In-Reply-To: <4FF9780D.4010709@nod.at>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig59249887AD4D85623A65E480"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig59249887AD4D85623A65E480
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Am 08.07.2012 14:07, schrieb Richard Weinberger:
> Hi Shmulik!
>=20
> Am 08.07.2012 13:47, schrieb Shmulik Ladkani:
>> +
>> +		/* TODO: if find_fastmap=3D=3D1, we do not enter this block at all.=

>> +		 * shouldn't we? shouldn't we care of compatability of unknown
>> +		 * internal volumes OTHER than the fastmap ones, even if
>> +		 * find_fastmap=3D=3D1?
>> +		 */
>> +
>=20
> If find_fastmap=3D1 we scan only the first 64 PEBs (now by using scan_p=
eb()).
> When using fastmap can do not care about compatibility of unknown inter=
nal volumes
> at all.
> Fastmap keeps only track of known (and compatible volumes).
> Taking care of unknown internal volumes would imply a full scan.

Please forget the above statement.
We have to think of the case where no fastmap was found and the
64 scanned PEBs get reused by scan_all().
Thanks for pointing this out!

Thanks,
//richard


--------------enig59249887AD4D85623A65E480
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJP+aM3AAoJEN9758yqZn9esSYIAJxgSb9+EgNvNphf1PvjCpNG
LfL4BMbO0oLa9SBvvwTFYAIZWxPu+R+0MCNc1cHqHCOqWr9ZbIV87AheHDg68pSB
3nxbSolEqSIXMilxmlFyrx6lvZddAi2yhh6onAM6EiB598BfYUGVsooHZMpGrDbY
RjoadObWJ0XS6dfR+TcAVLCbHBDNqP2k71cj9xFDlooL5/LXa5e3W2jxmXZSfKYt
3/wNF1xSYphxL4B/HxpHA5mbw7L447jourB2yhtIKVhRAplhp1k2rj476K2JgBM3
YoLiLl8q5eY/tklQisQAz1z/B7Uj1oeMLIDVP5GqCPcrWLwISv5kNHUjAPUTf8w=
=gwx4
-----END PGP SIGNATURE-----

--------------enig59249887AD4D85623A65E480--
