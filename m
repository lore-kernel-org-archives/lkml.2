Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab2HPGrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 02:47:53 -0400
Received: from len.romanrm.net ([176.31.121.172]:43865 "EHLO len.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754179Ab2HPGrt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 02:47:49 -0400
X-Greylist: delayed 393 seconds by postgrey-1.27 at vger.kernel.org; Thu, 16 Aug 2012 02:47:49 EDT
Date: Thu, 16 Aug 2012 12:41:12 +0600
From: Roman Mamedov <rm@romanrm.ru>
To: stan@hardwarefreak.com
Cc: Andy Lutomirski <luto@amacapital.net>,
        John Robinson <john.robinson@anonymous.org.uk>,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: O_DIRECT to md raid 6 is slow
Message-ID: <20120816124112.2aa22f3e@natsu>
In-Reply-To: <502C35D4.6010804@hardwarefreak.com>
References: <CALCETrWCu=UPATPdqWP=Gpvswv-RDwaxfr1W1jxYtUMZsqKgSQ@mail.gmail.com>
	<502B8D1F.7030706@anonymous.org.uk>
	<CALCETrX=mi92qwOAjt_7Qu-ho_Hdg_5SHX-_8nXYRer4JnzD0w@mail.gmail.com>
	<502C1C01.1040509@hardwarefreak.com>
	<CALCETrUTNV0r6xeF+mbqqw7w_StxoF2qFxzCLfb-LVH7ay_SHw@mail.gmail.com>
	<502C35D4.6010804@hardwarefreak.com>
Organization: http://version6.ru/
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/dsaBPJ6pCsVYX..ZlCWOvbw"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/dsaBPJ6pCsVYX..ZlCWOvbw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Aug 2012 18:50:44 -0500
Stan Hoeppner <stan@hardwarefreak.com> wrote:

> TTBOMK there are two, and only two, COW filesystems in existence:  ZFS an=
d BTRFS.

There is also NILFS2: http://www.nilfs.org/en/
And in general, any https://en.wikipedia.org/wiki/Log-structured_file_system
is COW by design, but afaik of those only NILFS is also in the mainline Lin=
ux
kernel AND is not aimed just for some niche like flash-based devices, but f=
or
general-purpose usage.

--=20
With respect,
Roman

~~~~~~~~~~~~~~~~~~~~~~~~~~~
"Stallman had a printer,
with code he could not see.
So he began to tinker,
and set the software free."

--Sig_/dsaBPJ6pCsVYX..ZlCWOvbw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAslggACgkQTLKSvz+PZwiUDQCffW5wJIP9cYRu0oiPxqXZ1jFN
fFoAoI8UZ1/wjlomjZNBSqxBp0c/fMps
=9b02
-----END PGP SIGNATURE-----

--Sig_/dsaBPJ6pCsVYX..ZlCWOvbw--
