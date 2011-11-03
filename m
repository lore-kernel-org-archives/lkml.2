Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab1KCVPO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 17:15:14 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:56012 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751381Ab1KCVPN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 17:15:13 -0400
Message-ID: <4EB3045A.6050501@nod.at>
Date: Thu, 03 Nov 2011 22:15:06 +0100
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Foley <pefoley2@verizon.net>, Michal Marek <mmarek@suse.cz>
Subject: Re: [GIT PULL] UML changes for 3.2
References: <4EB14F51.1050004@nod.at>  <1320348750.14409.249.camel@x61.thuisdomein>  <1320352899.14409.260.camel@x61.thuisdomein> <1320354072.14409.265.camel@x61.thuisdomein>
In-Reply-To: <1320354072.14409.265.camel@x61.thuisdomein>
X-Enigmail-Version: 1.3.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigA3E24897983A779C6269A5C2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigA3E24897983A779C6269A5C2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 03.11.2011 22:01, schrieb Paul Bolle:
> On Thu, 2011-11-03 at 21:41 +0100, Paul Bolle wrote:
>> 1) Note that running make update-po-config seems to do what it's
>> supposed to do. But it also prints this warning
>>     arch/um/Kconfig.common:66:warning: environment variable SUBARCH un=
defined

I'm confused. What is "make update-po-config" supposed to do?
It seems to iterate over all archs and reads their Kconfig, right?

>> (I haven't checked if it's new.) It seems harmless. I don't know what
>> should be done to make it go away.
> 2) Should I submit one (or two?) patch(es) to fix these minor issues?

I would send one patch.

Thanks,
//richard


--------------enigA3E24897983A779C6269A5C2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJOswRaAAoJEN9758yqZn9erQwIALyCoCjxCABXVuvh/YRI97kH
tWyxeQhHuTcUrXw32N9JFxCzvMl17v2JhxOr2CZLtk+Dc9l1+uCLxUNmOxqtQxeY
yjvuqjn8FcAdMQaR+VfQhwUWqTmOYR5oSl5yO58sIG2OTVwGlRbBMgS3r3bh7qcH
sM/x96dOtyLpivw7a1QUxZ1dZru4o5kcQVq4Fo9UOTFkTzHVBeMoA8+GREs8Aj6A
8RCXqmWqkieCYgZKgnHg6lBI0F1NkCQzNvRHl8l9sMFed/A9myk7nMcLydBXVI8s
21QRyb/+PFZSr5wORJLa/66Cd53uREMu2MlKXkldnYqfq5ZyQdlrhBFga5IqTEE=
=x2nl
-----END PGP SIGNATURE-----

--------------enigA3E24897983A779C6269A5C2--
