Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760925Ab2FDQ3R (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 12:29:17 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488Ab2FDQ3Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 12:29:16 -0400
Message-ID: <4FCCE255.4080705@nod.at>
Date: Mon, 04 Jun 2012 18:29:09 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120427 Thunderbird/12.0.1
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: Jiri Slaby <jslaby@suse.cz>, Jiri Slaby <jirislaby@gmail.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        gregkh@linuxfoundation.org, Jeff Dike <jdike@addtoit.com>,
        linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        alan@linux.intel.com
Subject: Re: [uml-devel] [PATCH 13/24] TTY: um/line, use tty from tty_port
References: <1338809738-18967-1-git-send-email-jslaby@suse.cz> <1338809738-18967-14-git-send-email-jslaby@suse.cz> <4FCCA3A6.8080608@nod.at> <4FCCD224.1020307@suse.cz> <4FCCD44A.3090500@nod.at> <4FCCD70D.5010908@suse.cz> <4FCCD774.5040003@nod.at> <4FCCE1D4.7080805@panasas.com>
In-Reply-To: <4FCCE1D4.7080805@panasas.com>
X-Enigmail-Version: 1.4.1
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDF3E0DC4F5EFFBA5938D6690"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDF3E0DC4F5EFFBA5938D6690
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Am 04.06.2012 18:27, schrieb Boaz Harrosh:
> On 06/04/2012 06:42 PM, Richard Weinberger wrote:
>=20
>> Am 04.06.2012 17:41, schrieb Jiri Slaby:
>>> Hmm, I remember. I suggest you to split the patch into several pieces=
=2E
>>> For example moving the code from ->open into ->install can be done
>>> separately. Otherwise it's hard to tell what's wrong with the patch a=
s
>>> a whole.
>>>
>>> Also, it would be good to see the patch rebased on the top of my
>>> patch, because tty_port_set/get pieces would be gone from your patch =
too.
>>
>> Okay, I'll redo it!
>> I've a much cleaner version in my local queue.
>>
>=20
>=20
> Can you send it my way, I'm still running broken, 3.4 Based ?
>=20

Can you please first give Jiri's patches a try?

[PATCH 12/24] TTY: um/line, add tty_port
[PATCH 13/24] TTY: um/line, use tty from tty_port

Thanks,
//richard


--------------enigDF3E0DC4F5EFFBA5938D6690
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJPzOJVAAoJEN9758yqZn9eJI0IAMBL/6Q3GufEJdaomEoZHRdj
oYqDLqxRwHjptJkFR4AI50cW7ePRib6YZiDn7UwSVMjSKIbojRxpWvOA+k//pCoT
OswQg4lV3hrOUQ7ZBYE5XFoMAMd1s3W4pLPs8ylPXLti+0wJTlu/r48GRaW15Al6
O9CExUX+3cln3969pHc0dONzteOYn0ZGl6i7r+MnOfBcQxMVtZUjki4GQgThltFt
ltSH1WUyU/VvloOXJ6b7/tvzdOROHtPBHPcz27mIix99ZqKLXIAE8Jhtd/wq9RDB
9NjD0Qvww7uds7E/QiATAU2LeTy6ZbIdU5fgrcnS1BLHwUFBZ9bMCvGfLnClOgo=
=KsSf
-----END PGP SIGNATURE-----

--------------enigDF3E0DC4F5EFFBA5938D6690--
