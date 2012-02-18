Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751921Ab2BRGXr (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 01:23:47 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:40324 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2BRGXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 01:23:46 -0500
Date: Sat, 18 Feb 2012 09:25:35 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jorgyano Vieira <jorgyano@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@linuxdriverproject.org,
        jarod@wilsonet.com, nsankar@broadcom.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Staging: crystalhd: Replace the BCMLOG_ERR macro
 with pr_err
Message-ID: <20120218062534.GB2855@mwanda>
References: <1329521976-1326-1-git-send-email-jorgyano@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="4bRzO86E/ozDv8r1"
Content-Disposition: inline
In-Reply-To: <1329521976-1326-1-git-send-email-jorgyano@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F3F43EC.006E,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--4bRzO86E/ozDv8r1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 17, 2012 at 09:39:36PM -0200, Jorgyano Vieira wrote:
> Replace the usage of BCMLOG_ERR with pr_err and remove the macro definiti=
on.
>

This needs a pr_fmt line so we can tell where the errors are coming
=66rom.

#define pr_fmt(fmt)     KBUILD_MODNAME ": %s:%d: " fmt, __func__, __LINE__

regards,
dan carpenter


--4bRzO86E/ozDv8r1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPP0ReAAoJEOnZkXI/YHqRlbYP/0n2wRP/h15bYa9df/r8drGM
HG00r2X2a7tAvmxXCTmlQG+nCuj1MgLZ9C4toN8Z3lNI/skUqXYwPHVLpJkkW7Zj
9I+p0BSx1tNjf2UyZmi4WhdCujcKJUCBwj5b/7L7UrPlmgsexwVoMq18EGgyfkxR
z3kXAu2F1j1oA7BWzA+I8fvX2M0LXT2nUuc2NFZ9akHzugmrGrH+jcOB6I38A70n
luaWLabFaC6RWibuu0scF29nakDO6eMvVnHgW/TQWEnv61gH4+qfW2NQoJBIFB3+
P4dckc5mhxaNhn1nRpyymwWtwdNioGrZ0FJcFJ9QJ7ho70GpiPs8TDlhoFyG/2y/
iw24pAPsbmfBbUBSfpMIdjet8wFzNbyNAmU3Ku15uYSi8OQVhaS4YNrcXTJIzOdn
3AfegcapENvoMOY4+pc3lNp1OPU5fMvl/nCb5Flf+AbkL9PTivFHVEUcRqNl9NMJ
GfWxwSj/K3Rmg0kHaHSB4pRjUw/g1F8jVhPCRCf4rUhA59uHxVJgWncCJtKNQyK5
DBve59XQ8LmG5SP9YW04ogaOlxdZeH7R5sLi8oCBZbzKVOaZsdeQT61wtTbAPgBh
TQAifh4efUxN3Nc1ZZ1SS52pBA7oWEoKteB1IxKgNN7Bdj5Cw2pjYNHLy6ajcPsy
RjZzPGjmMANeccO7JoFs
=Tfkf
-----END PGP SIGNATURE-----

--4bRzO86E/ozDv8r1--
