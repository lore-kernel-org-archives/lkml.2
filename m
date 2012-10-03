Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852Ab2JCNEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:04:47 -0400
Received: from mout.web.de ([212.227.17.12]:65370 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753044Ab2JCNEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:04:46 -0400
Message-ID: <506C37E1.4000305@web.de>
Date: Wed, 03 Oct 2012 15:04:33 +0200
From: Jan Kiszka <jan.kiszka@web.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); de; rv:1.8.1.12) Gecko/20080226 SUSE/2.0.0.12-1.1 Thunderbird/2.0.0.12 Mnenhy/0.7.5.666
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-kernel@vger.kernel.org, Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH 06/13] scripts/gdb: Add lx-dmesg command
References: <cover.1349263293.git.jan.kiszka@web.de> <805b20bb0e1fb1ec06acf8e50237cdb40dd54290.1349263293.git.jan.kiszka@web.de> <m2iparwy2g.fsf@firstfloor.org>
In-Reply-To: <m2iparwy2g.fsf@firstfloor.org>
X-Enigmail-Version: 1.4.4
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC3E1969B54387514F1A58CC9"
X-Provags-ID: V02:K0:mEshSZVO8ZVRRGlVVtLGAlRLvbMN1vtUa0RJl1bEH0v
 +9eaWvclkwjHNzMs4NTnnxAz+jy/93dGybuFQSwo2VicYabOXn
 eIdWSwAzLysLz+8b4OYPzsvkMqLGKuLlsiyabjyyCg6D2OxBEd
 F1V1145YLQEh3Wxa9lMaCYBHTblZvVW7iBCxmxROi3wMUKjV+v
 PuugRJwW+HXfLOhlq46Kw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC3E1969B54387514F1A58CC9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 2012-10-03 14:16, Andi Kleen wrote:
> Jan Kiszka <jan.kiszka@web.de> writes:
>=20
>> From: Jan Kiszka <jan.kiszka@siemens.com>
>>
>> This pokes into the log buffer of the debugged kernel, dumping it to t=
he
>> gdb console. Helping in case the target should or can no longer execut=
e
>> dmesg itself.
>=20
> Thanks. That's very useful. I recently ran into this problem that
> the new log buffer is a pain to dump from qemu gdb.
>=20
> fwiw there's already some kdump macros in Documentation/kdump=20
> Since you obsoleted them you could remove those (and for log buffer
> they do not work anymore)

Oh, indeed - and pretty dusty now. I would suggest to remove it when all
its feature are either broken or replaced by python scripts. Need to
look at the details, but stack backtraces is definitely still on the
todo list here.

>=20
> I don't like the lx-* prefixes.

In this case I think we could add the feature also under "dmesg". But I
would generally like to avoid potential namespace clashes with gdb or
other helpers, therefore the common prefix. Also, if you type
"lx-<tab>", you now get a list of all Linux-related commands.

Jan



--------------enigC3E1969B54387514F1A58CC9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://www.enigmail.net/

iEYEARECAAYFAlBsN+QACgkQitSsb3rl5xSKJACgnweBBxVbDdGL/GGTM1U/BM4o
MHoAoNwF/p0Yo3ZpOkBJj0MqjhX88Jow
=tdun
-----END PGP SIGNATURE-----

--------------enigC3E1969B54387514F1A58CC9--
