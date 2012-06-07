Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab2FGKT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 06:19:28 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab2FGKT1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 06:19:27 -0400
Message-ID: <4FD0802A.1020203@nod.at>
Date: Thu, 07 Jun 2012 12:19:22 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: user-mode-linux-devel@lists.sourceforge.net, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, jslaby@suse.cz,
        alan@linux.intel.com
Subject: Re: [uml-devel] um: TTY fixes (?)
References: <1338841657-30358-1-git-send-email-richard@nod.at> <4FCF6748.6020005@panasas.com> <4FD059AC.8050808@panasas.com> <4FD06A22.6040002@nod.at> <4FD07F14.50902@panasas.com>
In-Reply-To: <4FD07F14.50902@panasas.com>
X-Enigmail-Version: 1.4.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig152774F0D344CAEC166E004C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig152774F0D344CAEC166E004C
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 07.06.2012 12:14, schrieb Boaz Harrosh:
> On 06/07/2012 12:22 PM, Alan Cox wrote:
>> On 06/07/2012 11:45 AM, Richard Weinberger wrote:
>=20
>>>
>>> We cannot push this patch to Linus or -stable.
>>> The problem is that will break other things.
>>> E.g. login on non-tty0 terminals will break if the distro uses
>>> util-linux's login.
>>>
>=20
>=20
> I don't understand. Current code does not work at all even for
> tty0. as well as ttyX. Since 3-4 Kernels ago. I've been running with
> your patch for a long time.

Depends on your userspace.
On my setups it's very hard to trigger the bug.

> I really don't get it. You have not broken anything new. Only
> not fixed all of the problems. Current code does not work for "non-tty0=

> terminals" as well right?

No, it works fine.

> I don't see Alan's comment at all. This is not a regression it was alwa=
ys
> like that. Ever since Fedora was working on UML, But these fixes are re=
al
> live regression crashes.
>=20
> And I don't see the all "leaving other vendors systems insecure". It ju=
st
> a freaking UML tty. You need to be root 5 times before you have access
> to all these, and it's only the UML that's compromised not the "all sys=
tem"
> And surely the current plain tty0 crash is much less secure then this t=
hing.

The "TTY problem" is not UML specific.

Thanks,
//richard


--------------enig152774F0D344CAEC166E004C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJP0IArAAoJEN9758yqZn9erGQIAJBTjBQ59wHunLmiUYxNtP2V
A94m0M7ukYhZHMC3a6VMsd6wBuxd1rKDC44nugG6vTVombusXrRGEtETb8sjFb+c
5PHgvDoIzQlroY8FHetHE1+3km05n+oWum4cY5/yjPnUWVcmGs5vgOkA8xP3V8hy
EO05U6oAaa7md4c5GqR317A6Cs5ZQbUpzzPhDD+SeSrh/8f3XQ/LJ664UHVx7V9j
avQKQ232CCV2mllTClIqBbNvSXPkliYiuGkloi2TFJntUBChtNR6tYHwmta1V+i/
hnHPV4LGi5iHzN1GQqEq7Mjf6XLCxfnXwTxTzQKv2CCHRHId2t/9YLxNA8MFTwk=
=DfZC
-----END PGP SIGNATURE-----

--------------enig152774F0D344CAEC166E004C--
