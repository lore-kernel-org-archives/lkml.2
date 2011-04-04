Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab1DDOkZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 10:40:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56417 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533Ab1DDOkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 10:40:24 -0400
Date: Tue, 5 Apr 2011 00:40:11 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thomas Renninger <trenn@suse.de>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>,
        Len Brown <lenb@kernel.org>, "Greg Kroah-Hartman" <gregkh@novell.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Linus <torvalds@linux-foundation.org>
Subject: Re: [SUBMIT REQUEST] cpupowerutils for linux-next
Message-Id: <20110405004011.0628991a.sfr@canb.auug.org.au>
In-Reply-To: <201104041510.56570.trenn@suse.de>
References: <201104041510.56570.trenn@suse.de>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__5_Apr_2011_00_40_11_+1000_+9cxAH9rKqU2TUWx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Apr_2011_00_40_11_+1000_+9cxAH9rKqU2TUWx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thomas,

On Mon, 4 Apr 2011 15:10:56 +0200 Thomas Renninger <trenn@suse.de> wrote:
>
> this is about the recently announced cpupowerutils project
> based on or say an enhancement of the well know
> cpufrequtils project:
> http://www.spinics.net/lists/cpufreq/msg02137.html

Has integration of this into the kernel sources been discussed anywhere
generally (like lkml)?  Has the work been done to integrate it into the
kernel build system (I am not sure what this involves for the tools
directory).  At a first glance, it doesn't need it own copy of the
COPYING file (for example).

I see that you asked Linus about this, but have receibed no reply (on
list).

Code being merged into linux-next should be basically ready for merging
into Linus' tree (apart from integration testing) and you need to be
pretty sure that it will be merged by Linus into the next release (i.e.
2.6.40).  In this case that is not such a big issue as the code is
(currently) all in a new directory, so will not interfere with other code.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__5_Apr_2011_00_40_11_+1000_+9cxAH9rKqU2TUWx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNmdhLAAoJEDMEi1NhKgbs4J4H/3J/vmumomNKLKywxkowU/nf
X7yHqlr3siXhzzIgwY3klGW2a7mbP/sE81DyhW02IaJZXtqud7vso4FiB+ZDdT8a
hSaNEQYYw0FywRwOP0BothZ5WzSzwFNJcErv5Br2pKnUvj975p+GwHEeYYdNXHsV
l5ltNT6eeOPg61mnZTvqTf5zd4m1vvuJ4KOKrzsCKgwmR3thct3uRUMU32IBcSQt
ChLd2p5OZ0QHA43tEm1mtO04FeEfTSN1tXMfL/QrRdj/b+EBNitb5lNI3YijMzkU
83EhqfbcbUUY1iDSutdpTXN87fu4752j8wMpSFJwP0/0TiY8xQ//ONMnDMsbkYA=
=VuoL
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Apr_2011_00_40_11_+1000_+9cxAH9rKqU2TUWx--
