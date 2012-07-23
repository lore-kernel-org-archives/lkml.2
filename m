Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754403Ab2GWRls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 13:41:48 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45767 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab2GWRlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 13:41:47 -0400
Message-ID: <500D8CD0.7030902@kernel.org>
Date: Mon, 23 Jul 2012 10:41:36 -0700
From: Konstantin Ryabitsev <mricon@kernel.org>
Organization: Linux Foundation/Kernel.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
CC: "John 'Warthog9' Hawley" <warthog9@kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, users@kernel.org
Subject: Re: [kernel.org users] [KORG] lkml.kernel.org up and running
References: <5000B5D1.3090307@kernel.org> <20120723130642.GA4572@breakpoint.cc>
In-Reply-To: <20120723130642.GA4572@breakpoint.cc>
X-Enigmail-Version: 1.4.3
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAEDCB69D4B881507F231F3EC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAEDCB69D4B881507F231F3EC
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On 23/07/12 06:06 AM, Sebastian Andrzej Siewior wrote:
> |wget
> |'http://lkml.kernel.org/r/1342156917-25092-2-git-send-email-john.stult=
z@linaro.org'
> |--2012-07-23 15:05:14--
> |http://lkml.kernel.org/r/1342156917-25092-2-git-send-email-john.stultz=
@linaro.org
> |Resolving lkml.kernel.org (lkml.kernel.org)... 198.145.19.208, 198.145=
=2E19.209
> |Connecting to lkml.kernel.org (lkml.kernel.org)|198.145.19.208|:80...
> |connected.
> |HTTP request sent, awaiting response... 500 Internal Server Error
> |2012-07-23 15:05:14 ERROR 500: Internal Server Error.

This was fixed at 16:30 +0000.

Sorry about the problem -- it was caused by a bug in the upstream
selinux policy for suexec.

Best,
--=20
Konstantin Ryabitsev
Systems Administrator
Linux Foundation, kernel.org
Montr=C3=A9al, Qu=C3=A9bec


--------------enigAEDCB69D4B881507F231F3EC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQGcBAEBAgAGBQJQDYzQAAoJEI6WedmufEleBAUL/2FSObMeyVFlWu+mGfg47Vch
0OKI9kiAI0Reb+UN9CFZqRfYn8v5jCHIHOvmq2t38YHvllHUNRou7FuU+UZCpDRE
8CGt46urzTW3uYwI71V+feYTdJmmDoH1iQLUY8RWowUws+B9NdEUEWh2irKRFF0X
L9cq1sQlmLtSTSzOfdL71BbegKf7YWQWzIeJ+6OHOER+Vx/eWZM3+3cJFWv3elw1
dwa6nZn3Dj6o0oZHJGogANZeQaPe9fD7xMlXzfbJ3Q7rfW2FoTci7MvwvO9LyHji
aMvF6xYJ7z41JKRE2AEm8vyzLuRvVPOvFzxpWVK+lscS58krAJhsE5o+ETHoJoFh
cB8QYE4mVsC11mPAPo3CAuwPY4ZabIoxRMHWRzXniRGCTsQ0XX1kQsl1t5GdXRry
lefGXqOeBwp19+pefuN9LN8dYqDuNTYU1WHPbUnXpQ4il3C+MCU0e458g1JMoTdn
6MXlTldxTl1QLDsdubMD/nAZNoSi2ZS3EywoOOeuwA==
=jBHr
-----END PGP SIGNATURE-----

--------------enigAEDCB69D4B881507F231F3EC--
