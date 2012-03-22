Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757359Ab2CVRSS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:18:18 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41670 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2CVRSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:18:14 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.4-dev
To: Jiri Slaby <jslaby@suse.cz>
Cc: Phil Carmody <ext-phil.2.carmody@nokia.com>, apw@canonical.com,
        hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] checkpatch.pl: thou shalt not use () or (...) in function declarations
In-Reply-To: Your message of "Thu, 22 Mar 2012 17:55:38 +0100."
             <4F6B598A.7090909@suse.cz>
From: Valdis.Kletnieks@vt.edu
References: <1332430038-21057-1-git-send-email-ext-phil.2.carmody@nokia.com> <4F6B51C9.6010904@suse.cz> <4517.1332434943@turing-police.cc.vt.edu>
            <4F6B598A.7090909@suse.cz>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1332436627_1970P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 22 Mar 2012 13:17:07 -0400
Message-ID: <6258.1332436627@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Junkmail-Status: score=10/50, host=zidane.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020204.4F6B5E94.0106,ss=1,re=0.000,fgs=0,
	ip=0.0.0.0,
	so=2011-07-25 19:15:43,
	dmn=2011-05-27 18:58:46,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1332436627_1970P
Content-Type: text/plain; charset=us-ascii

On Thu, 22 Mar 2012 17:55:38 +0100, Jiri Slaby said:
> On 03/22/2012 05:49 PM, Valdis.Kletnieks@vt.edu wrote:
> > Is there any *legitimate* use of an empty parameter list in the
> > kernel tree?
>
> Yeah, a ton of them. There are many drivers which work with a global
> singleton. So they need no argument.

Those can be 'int foo(void)' can't they?  The other historical usage is for
'int foo()' to denote an old K&R-style varargs list, which is like disco - a
bad idea from long agon that's never coming back. ;)

Of course, if we add this to checkpatch, we'll have a flood of fixup patches.
Maybe we just need to say "3.5 will be the int foo() housecleaning release" and
be done with it?


--==_Exmh_1332436627_1970P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBT2tekwdmEQWDXROgAQIA3Q//aUefdMLNGCkOn2xN/zlh8fu21yNH1YT9
+GmW2KKsKBsjJ+5n1Q/ho5/GX+Qyo1yd6uU/XLybYf7dT6VYNKrxtSmgZa9WOKv0
0Lwunt360gVXq97MhxPNREANyl9nv9O/UM4v/m51sZnF+4i+GhB3q4aAKwUcaW18
N574wHutn7K/hRhc9WIvTbePON0mXCbTV2aAwHTMI/+kDOF99gePar7HrP/kx2IQ
TA1MJOlY1DFJGRpYhTIfhHvcN6bhn0MOt+/xEcRyKcZ2LtQFGCIVHmlJnjmzlMs0
0FDFjUMhYeYIajcUGZuEFbRCCGuNWNPJ9n4+B40MODy0g/F+kjF7Kg5waDeI00zv
GjZn0EKGfRNWaGC6OqRfwbp/apbotNvqXzI8rlXq/BNZiXbRRDo6OO1sXqbQgbNM
nTzID6Fea2QtXqQNbgnD3+H/V8tnp6B/8Eqo+tGS0d0WwmeDUPwJN+u3qjSik+/g
JXwk5GtkMP3RC8YLhatEOEYlchQlgvGpYDOWBXovehtru1o5zxD+yeGT9iVlV8q2
ympJSOWT6srK9pi241hY2aYuMJKR8w5ey4szUynLGKrSKfSNvzOmb5uxkk6JeMhf
CoC6tMEtqKgK9LvQ5csZ7VqB1aJMugvU/NUB941YiM8obwdZuuFOP57GONeuJqGg
3nkOYHRlMb0=
=hrex
-----END PGP SIGNATURE-----

--==_Exmh_1332436627_1970P--

