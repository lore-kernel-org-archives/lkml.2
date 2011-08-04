Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab1HDXE3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 19:04:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:55442 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751362Ab1HDXEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 19:04:24 -0400
Date: Fri, 5 Aug 2011 09:04:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@nvidia.com>
Cc: Len Brown <len.brown@intel.com>,
        "Mark Brown (broonie@opensource.wolfsonmicro.com)" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: next-200110804 ARM build break (cpuidle_call_idle)
Message-Id: <20110805090413.c06fd0e178a6bb56ea7078c9@canb.auug.org.au>
In-Reply-To: <74CDBE0F657A3D45AFBB94109FB122FF049EEAB704@HQMAIL01.nvidia.com>
References: <74CDBE0F657A3D45AFBB94109FB122FF049EEAB704@HQMAIL01.nvidia.com>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__5_Aug_2011_09_04_13_+1000_YUM6oq75A_8+lPcH"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Aug_2011_09_04_13_+1000_YUM6oq75A_8+lPcH
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Stephen,

[Just quickly responding to one part of your email]

On Thu, 4 Aug 2011 13:35:59 -0700 Stephen Warren <swarren@nvidia.com> wrote:
>
> Related, I see that linux-next merges
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-acpi-2.6.git idl=
e-test
> yet that branch doesn't seem to exist anymore.

I actually get that branch from linux-idle-2.6.git - I had a typo in my
documentation, but was still fetching the correct tree.  Sorry about the
confusion.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__5_Aug_2011_09_04_13_+1000_YUM6oq75A_8+lPcH
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOOyVtAAoJEDMEi1NhKgbsAKcH/2krlNQsmpclJfBf5UqfU7d0
443YAP/tfOMdbgXugupzT9OJIapscxgJfrJ4VvTE0ua+gtREMrnbN/Hep5JBgLUi
65vAFItph/eFsZ6THcXvqsL8MFFsgfAcAl7hLa+cIW4l5ojk5c1bd5hwLHvBPDCV
Xyo/wIU9p/0TZd7mt5blgWNnQuJMxftnJ8STRxjdvDSgy6dUATa7Tt1sVgIsUyXX
a6bjbmmzFQqRc7XDy6Fz6JJ0ZiTWcN8zAcF4sWOz6V30Me1nn6r1xwuft5s6riE6
JvObb/p2HOia8bPNhLRoIKxVWIL1nuErzTB+qr0p02NrOZHcZS8p+qLqLSOhsQ4=
=Ux6A
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Aug_2011_09_04_13_+1000_YUM6oq75A_8+lPcH--
