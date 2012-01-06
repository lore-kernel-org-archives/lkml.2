Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759090Ab2AFUMA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:12:00 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:59579 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759063Ab2AFUL6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:11:58 -0500
Date: Fri, 6 Jan 2012 12:11:54 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com, linux-pci@vger.kernel.org, tglx@linutronix.de,
        mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Subject: Re: [PATCH 1/6] pci_ids: add device ids for STA2X11 device (aka
 ConneXT)
Message-ID: <20120106121154.48b570e8@jbarnes-desktop>
In-Reply-To: <3bffc0889fba822f58b5f8607fa5247c6f50649c.1325852059.git.rubini@gnudd.com>
References: <3bffc0889fba822f58b5f8607fa5247c6f50649c.1325852059.git.rubini@gnudd.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/1my=IDcKxZ4cfsKToomJrY9"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/1my=IDcKxZ4cfsKToomJrY9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 6 Jan 2012 13:32:41 +0100
Alessandro Rubini <rubini@gnudd.com> wrote:

> The chip is an I/O hub used by some Atom boards.  Most of those
> symbols are used in arch/x86/platform/sta2x11/sta2x11.c (to be
> introduced) and in the specific drivers as well.
>=20
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> Cc: Alan Cox <alan@linux.intel.com>
> ---

Applied, thanks.  Will the users land this release too?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/1my=IDcKxZ4cfsKToomJrY9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPB1WLAAoJEIEoDkX4Qk9hKv4QAJiKhE2q4aw+tpnWm8RzzZvx
jwpAoVRgs3raHCORRdwqVB5GjXuiluG/DjGa8Sv4bScesKoRUXiXE8Qn7TEY4LQL
6LDK0GMkJigCwmC88cPW2PTrz/tMHP4J1J1F1nkPBSbkrDGMDix/XIUDrUqPzYKt
acjkAdrvuAfGtdSWqv8vNaDHm1CLUsEOZz/evkk9f0SKDrDJGyIlBQNffqOPATon
XyoPAbv5EXeCTrvTEoT8/9OtorQwLgY/vv4PImPfOuzg5WhFrxSXlF9pGU3Npt3E
qBJ4N8Sfhwraq2YXJ6cRF0y8vAD6II6HV4a94/RG3SUQwtf0U+lPhcJ4kCFp6KYN
stexzsH8JiQ/vQ4PWkG3wBX3LXAjXLnPQV4/13o8GEJn7ou+mL9//Y0ViVqJq1q6
O4SgiC/tUGrYu0IgT7RuP5nuG1ejf1Ke8ggYTdAy3STzG8zM5T5u4efmHBkGzl2R
ZssjGixWf+Dck2LQeCdH1yrMfeesHbdWKPqtVItF/YR5/jKLazcDeTrVnM7kUeU4
wpuIhOlGXOfHXBFPQYwf70u+q8G//UhGN6C2Mpl0lZWV4KSXZyBBSBVeR3zrpp2t
cuQp9pGVBIYKMMcXuTso4A/vzgeoeksALNcdbGEoFkFIL+FqKNDByRTJci6YDJvD
9EnxGYI6qZAZh2jkjDyK
=3AQ0
-----END PGP SIGNATURE-----

--Sig_/1my=IDcKxZ4cfsKToomJrY9--
